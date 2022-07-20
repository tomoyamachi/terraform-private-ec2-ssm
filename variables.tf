variable "name" {
  type        = string
  description = "VPC and Instance name."
  default     = "test"
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
# default = "OrganizationAccountAccessRole"
}

locals {
  tags = {
    "Name"         = var.name,
    "generated-by" = "terraform"
  }
#  tags     = merge(local.generated_tags, var.tags)
#  tags_map = flatten([
#  for key in keys(local.tags) : {
#    key   = key
#    value = local.tags[key]
#  }
#  ])
}