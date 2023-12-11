output "ec2_instance_id" {
  description = "The ID of the created EC2 instance"
  value       = aws_instance.aws_vpn.id
}

output "ec2_instance_ami" {
  description = "The AMI used to launch the EC2 instance"
  value       = aws_instance.aws_vpn.ami
}

output "ec2_instance_public_ip" {
  description = "The public IP address of the created EC2 instance"
  value       = aws_instance.aws_vpn.public_ip
}

output "ec2_instance_key_name" {
  description = "The key name used to launch the EC2 instance"
  value       = aws_instance.aws_vpn.key_name
}

output "ec2_instance_availability_zone" {
  description = "The Availability Zone in which the EC2 instance was launched"
  value       = aws_instance.aws_vpn.availability_zone
}

output "ec2_instance_type" {
  description = "The type of EC2 instance"
  value       = aws_instance.aws_vpn.instance_type
}

output "ec2_instance_name" {
  description = "The name of the EC2 instance"
  value       = aws_instance.aws_vpn.tags_all["Name"]
}