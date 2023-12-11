locals {
  ec2_tags = {
    CreatedBy = "Terraform"
    AZ        = var.availability_zone
    Name      = var.ec2_instance_name
  }

  security_group_tags = {
    CreatedBy = "Terraform"
    AZ        = var.availability_zone
    Name      = "VPN-SG"
  }
}

provider "aws" {
  region = var.availability_zone != "" ? substr(var.availability_zone, 0, length(var.availability_zone) - 1) : ""
}

resource "tls_private_key" "tls_gen" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "terraform-key-pair"
  public_key = tls_private_key.tls_gen.public_key_openssh
}

resource "null_resource" "sensitive_provisioner" {
  provisioner "local-exec" {
    command = "echo '${tls_private_key.tls_gen.private_key_pem}' > ${var.secret_key_name_location} && chmod 0600 ${var.secret_key_name_location}"
  }
}

resource "aws_instance" "aws_vpn" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  availability_zone      = var.availability_zone
  vpc_security_group_ids = [aws_security_group.allowed_traffic.id]
  key_name               = aws_key_pair.generated_key.key_name
  tags                   = local.ec2_tags

  provisioner "file" {
    source      = "${path.module}/scripts/vpn-setup.sh"
    destination = "/tmp/vpn-setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "export PUBLIC_IP=${self.public_ip}",
      "export DEVICES=${var.devices}",
      "export TIMEZONE=${data.external.local_timezone.result.timezone}",
      "chmod +x /tmp/vpn-setup.sh",
      "/tmp/vpn-setup.sh",
    ]
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.tls_gen.private_key_pem
    host        = self.public_ip
  }

  provisioner "local-exec" {
    command = "scp -r -o StrictHostKeyChecking=no -i ${var.secret_key_name_location} ubuntu@${self.public_ip}:~/wireguard/config/peer* ${var.local_filepath}"
  }
  depends_on = [null_resource.sensitive_provisioner]
}

resource "aws_security_group" "allowed_traffic" {
  name        = "Allow SSH & Wireguard"
  description = "Allow SSH inbound traffic"
  tags        = local.security_group_tags

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 51820
    to_port     = 51820
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
