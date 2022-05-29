variable "name" {
  type = string
  description = "VPC and Instance name."
}

variable "instance" {
  type = string
  default = "t2.medium"
}

locals {
  tags = {
    "Name" = var.name,
    "generated-by" = "terraform"
  }
}