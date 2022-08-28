####################
# VPC Endpoint
####################
data "aws_iam_policy_document" "vpc_endpoint" {
  statement {
    effect    = "Allow"
    actions   = [ "*" ]
    resources = [ "*" ]
    principals {
      type = "AWS"
      identifiers = [ "*" ]
    }
  }
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ssm"
  policy            = data.aws_iam_policy_document.vpc_endpoint.json
  subnet_ids = [
    aws_subnet.sub_privatelink_1a.id
  ]
  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.ssm.id
  ]
  tags = merge(local.tags, {Name="${var.name}-ssm"})
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ssmmessages"
  policy            = data.aws_iam_policy_document.vpc_endpoint.json
  subnet_ids = [
    aws_subnet.sub_privatelink_1a.id
  ]
  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.ssm.id
  ]
  tags = merge(local.tags, {Name="${var.name}-ssm-messages"})
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ec2messages"
  policy            = data.aws_iam_policy_document.vpc_endpoint.json
  subnet_ids = [
    aws_subnet.sub_privatelink_1a.id
  ]
  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.ssm.id
  ]
  tags = merge(local.tags, {Name="${var.name}-ec2-messages"})
}

####################
# VPC Endpoint Security Group
####################
resource "aws_security_group" "ssm" {
  name        = "${var.name}-ssm-endpoint"
  description = "${var.name}-ssm-endpoint"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol  = "tcp"
    cidr_blocks = [
      "10.0.0.0/16"
    ]
  }

  tags = merge(local.tags, {Name="${var.name}-ssm-endpoint"})
}