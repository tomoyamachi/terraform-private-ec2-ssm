####################
# VPC
####################
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = var.tags
}

####################
# Subnet
####################
resource "aws_subnet" "sub_privatelink_1a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"

  tags = var.tags
}

resource "aws_subnet" "sub_app_1a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.11.0/24"
  availability_zone = "ap-northeast-1a"
  tags = var.tags
}

resource "aws_route_table" "privatelink_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = var.tags
}

resource "aws_route_table" "app_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = var.tags
}

resource "aws_route_table_association" "sub_privatelink_1a_rt_assocication" {
  subnet_id      = aws_subnet.sub_privatelink_1a.id
  route_table_id = aws_route_table.privatelink_rt.id
}

resource "aws_route_table_association" "sub_app_1a_rt_assocication" {
  subnet_id      = aws_subnet.sub_app_1a.id
  route_table_id = aws_route_table.app_rt.id
}