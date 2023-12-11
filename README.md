# Terraform AWS EC2 Wireguard VPN
Terraform module using an AWS instance and shell code to provision a Wireguard VPN based on an AWS Region.

## Supported Systems
The VPN module supports the following operating systems for this Terraform configuration:
- Linux
- MacOS
- Windows Subsystem for Linux (WSL)

## Contributing Guidelines
To contribute to this project, please follow these guidelines:

1. Fork the repository and create a new branch for your contributions.
2. This repo uses [pre-commit](https://pre-commit.com/index.html) when committing to branches for Terraform validations.
Please install the Python dependency for pre-commit and run the command `pre-commit install` once you pull down the repo to automatically configure pre-commit hooks defined in `.pre-commit-config.yaml`.
3. Make your changes and ensure they adhere to the project's coding style and conventions.
4. Write clear and concise commit messages for each logical change.
5. Before submitting a pull request, run the necessary tests and ensure they pass.
6. Provide a detailed description of your changes in the pull request, including any relevant information or context.

## Prerequisites for Terraform module execution
To run this Terraform configuration, you will need to have the following prerequisites installed:
- [Terraform](https://www.terraform.io/downloads.html)

- AWS Account: You will need an AWS account to provision the VPN resources. If you don't have one, you can create a free account at [https://aws.amazon.com/free](https://aws.amazon.com/free).

- Configure Terraform to connect to AWS, to do this you can read the official [Terraform AWS Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration).

Please ensure you have these prerequisites in place before running the Terraform configuration.

## Configuring the Terraform VPN Module

### Terraform Providers
List of Terraform required providers for the module.

| Name | Version |
|------|-------------|
| `terraform` | `>=1.6` |
| `aws` | `>=5.30.0` |
| `tls` | `>=4.0.5` |
| `null` | `>=3.2.2` |
| `external` | `>=2.3.2` |

### Inputs
To configure the Terraform VPN module, you need to provide values for these inputs in your Terraform configuration file.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `local_filepath` | The local path to store output Wireguard configs and QR codes to connect | `string` | N/A | Yes |
| `availability_zone` | The AWS AZ where the VPN resources will be provisioned | `string` | `us-east-1a` | No |
| `ec2_instance_name` | The name of the EC2 instance that will be provisioned | `string` | `terraform-vpn` | No |
| `instance_type` | Defines the AWS EC2 instance type | `string` | `t2.micro` | No |
| `devices` | List of comma separated devices to provide configs for AWS Wireguard VPN | `string` | `vpn1` | No |
| `secret_key_name_location` | The filepath to store the generated secret key for connecting to the EC2 instance | `string` | `~/ec2-private-key.pem` | No |

### Outputs
Defines the outputs that are returned from the module to the Terraform code referencing the module source.
| Name | Description |
|------|-------------|
| `ec2_instance_id` | The ID of the created EC2 instance |
| `ec2_instance_ami`| The AMI used to launch the EC2 instance |
| `ec2_instance_public_ip` | The public IP address of the created EC2 instance |
| `ec2_instance_key_name` | The key name used to launch the EC2 instance |
| `ec2_instance_availability_zone` | The Availability Zone in which the EC2 instance was launched |
| `ec2_instance_type` | The type of EC2 instance |
| `ec2_instance_name` | The name of the EC2 instance |


### Sample Terraform VPN Module Usage
```terraform
module "aws_vpn" {
  source            = "../modules/vpn"
  ec2_instance_name = "sample-vpn"
  availability_zone = "eu-west-3a"
  local_filepath    = "../../wireguard-configs"
  devices           = "test1,test2"
}
```

### Sample Output Wireguard Conf
Sample output conf file used to connect to the EC2 instance with the Wireguard GUI.
```
[Interface]
PrivateKey = YOUR_PRIVATE_KEY
Address = 10.0.0.2/32
ListenPort = 51820
DNS = 10.0.0.1

[Peer]
PublicKey = PEER_PUBLIC_KEY
AllowedIPs = 0.0.0.0/0
Endpoint = PEER_IP_ADDRESS:51820
```