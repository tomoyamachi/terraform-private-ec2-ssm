variable "name" {
  type = string
  description = "VPC and Instance name."
}

variable "instance" {
  type = string
  default = "t2.medium"
}

variable "tags" {
  type = map(string)
  default = {
    "Name" = "by-terraform"
  }
}