variable "name" {
  type        = string
  description = "VPC and Instance name."
}

variable "image_id" {
  type    = string
}

variable "instance" {
  type    = string
  default = "t2.medium"
}

variable "block_volume_size" {
  type    = number
  default = 16
}

variable "session_role" {
  type    = string
  description = "接続するユーザが利用するRole ex) OrganizationAccountAccessRole"
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