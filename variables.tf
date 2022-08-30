variable "name" {
  type        = string
  description = "prefix of resource name"
}

variable "image_id" {
  type    = string
  description = "AMI Image ID. Use latest Amazon Linux2 AMI when set empty value"
}

variable "instance" {
  type    = string
  default = "t2.medium"
}

variable "key_name" {
  type    = string
  description = "ssh-keygen -t rsa -f <here> -N ''"
}

variable "spot_instance" {
  type    = bool
}

variable "block_volume_size" {
  type    = number
  default = 16
}

variable "session_role" {
  type    = string
  description = "User session role ex) OrganizationAccountAccessRole"
}

data "aws_availability_zones" "available" {
  state = "available"
}
data "aws_region" "current" {}

locals {
  tags = {
    "Name"         = var.name,
    "generated-by" = "terraform"
  }
}