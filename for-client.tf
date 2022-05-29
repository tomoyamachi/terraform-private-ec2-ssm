data "aws_caller_identity" "current" {}


####################
# VPC Endpoint IAM Role
####################
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect    = "Allow"
    actions   = [ "sts:AssumeRole" ]
    principals {
      type = "AWS"
      identifiers = [ data.aws_caller_identity.current.arn ]
    }
#    condition {
#      test     = "Bool"
#      variable = "aws:MultiFactorAuthPresent"
#      values   = ["true"]
#    }
  }
}

resource "aws_iam_role" "session_role" {
  name               = "SessionRoleforSSM"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "ssm_startsesstion" {
  statement {
    effect    = "Allow"
    actions   = [ "ssm:StartSession" ]
    resources = [
      "arn:aws:ec2:*:*:instance/*",
      "arn:aws:ssm:*:*:document/AWS-StartSSHSession"
    ]
  }
}

resource "aws_iam_role_policy" "session_role" {
  name = "SSMSession_policy"
  role = aws_iam_role.session_role.id
  policy = data.aws_iam_policy_document.ssm_startsesstion.json
}