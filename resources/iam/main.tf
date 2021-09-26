data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "bastion" {
  name               = "s3_key_access"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
}

resource "aws_iam_role" "webserver" {
  name               = "s3_full_access"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
}

resource "aws_iam_role" "webserver_read" {
  name               = "s3_read_access"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
}

resource "aws_iam_instance_profile" "bastion" {
  name = "s3-pubkey-access"
  role = aws_iam_role.bastion.name
}

resource "aws_iam_instance_profile" "webserver" {
  name = "s3-full-access"
  role = aws_iam_role.webserver.name
}

resource "aws_iam_instance_profile" "webserver_read" {
  name = "s3-read-access"
  role = aws_iam_role.webserver_read.name
}

resource "aws_iam_role_policy" "bastion" {
  name   = "s3_key_policy"
  role   = aws_iam_role.bastion.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${var.s3_pubkey_bucket_name}",
        "arn:aws:s3:::${var.s3_pubkey_bucket_name}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "webserver" {
  name   = "s3_ec2_full_policy"
  role   = aws_iam_role.webserver.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["s3:*"],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${var.s3_pubkey_bucket_name}",
        "arn:aws:s3:::${var.s3_pubkey_bucket_name}/*",
        "arn:aws:s3:::${var.user_s3_bucket}",
        "arn:aws:s3:::${var.user_s3_bucket}/*"
      ]
    },
    {
      "Action": ["ec2:*"],
      "Effect": "Allow",
      "Resource": ["*"]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "webserver_read" {
  name   = "s3_read_policy"
  role   = aws_iam_role.webserver_read.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:Get*",
        "s3:List*"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${var.s3_pubkey_bucket_name}",
        "arn:aws:s3:::${var.s3_pubkey_bucket_name}/*",
        "arn:aws:s3:::${var.user_s3_bucket}",
        "arn:aws:s3:::${var.user_s3_bucket}/*"
      ]
    }
  ]
}
EOF
}
