
variable "availability_zone" {
  description = "The Availability Zone to be used"
  type        = string
  default     = "us-east-1a"

  validation {
    condition     = can(regex("^([a-z]{2}-[a-z]+-[1-9][a-z]?)$", var.availability_zone))
    error_message = "The Availability Zone must be a valid AWS Availability Zone."
  }
}

variable "ec2_instance_name" {
  description = "The name of the EC2 instance"
  type        = string
  default     = "terraform-vpn"

  validation {
    condition     = length(var.ec2_instance_name) >= 4
    error_message = "The EC2 instance name must be at least 4 alphanumeric characters long."
  }
}

variable "instance_type" {
  description = "The type of EC2 instance"
  type        = string
  default     = "t2.micro"

  validation {
    condition     = can(regex("^(t2\\..+|m5\\..+)$", var.instance_type))
    error_message = "The instance type must be a valid EC2 instance type."
  }
}

variable "devices" {
  description = "List of comma seperated devices to be used for the VPN"
  type        = string
  default     = "vpn1"

  validation {
    condition     = can(regex("^[a-zA-Z0-9]+(,[a-zA-Z0-9]+)*$", var.devices))
    error_message = "The devices input must be alphanumeric characters separated by a comma."
  }
}

variable "local_filepath" {
  description = "The filepath to copy the compressed wireguard connection files to on the local machine"
  type        = string
}

variable "secret_key_name_location" {
  description = "The filepath to store and use the generated secret key used to connect to the EC2 instance"
  type        = string
  default     = "~/ec2-private-key.pem"
}
