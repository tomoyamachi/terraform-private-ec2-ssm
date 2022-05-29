data "aws_ami" "example" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}


####################
# EC2
####################
resource "aws_instance" "ec2" {
  # Amazon Linux 2
  ami                    = data.aws_ami.example.image_id
  instance_type          = var.instance
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name               = aws_key_pair.example.id
  subnet_id              = aws_subnet.sub_app_1a.id


  # IAM Role
  iam_instance_profile = "EC2RoleforSSM"

  # EBS最適化を有効
  #  ebs_optimized = true
  # EBSのルートボリューム設定
#  root_block_device {
#    # ボリュームサイズ(GiB)
#    volume_size           = 8
#    # ボリュームタイプ
#    volume_type           = "gp3"
#    # GP3のIOPS
#    iops                  = 3000
#    # GP3のスループット
#    throughput            = 125
#    # EC2終了時に削除
#    delete_on_termination = true
#
#    tags = local.tags
#  }

  tags = local.tags
}

####################
# EC2 Security Group
####################
resource "aws_security_group" "ec2" {
  name        = "${var.name}-ec2"
  description = "${var.name}-ec2"
  vpc_id      = aws_vpc.vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}


####################
# EC2 IAM Role
####################
data "aws_iam_policy_document" "ssm_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_instance_profile" "ssm_role" {
  name = "EC2RoleforSSM"
  role = aws_iam_role.ssm_role.name
}

resource "aws_iam_role" "ssm_role" {
  name               = "EC2RoleforSSM"
  assume_role_policy = data.aws_iam_policy_document.ssm_role.json
}

resource "aws_iam_role_policy_attachment" "ssm_role" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}