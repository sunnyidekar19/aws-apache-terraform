resource "aws_iam_role" "main" {
  name = "s3-pubkey-access"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "main" {
  name = "s3-pubkey-access"
  role = aws_iam_role.main.name
}

resource "aws_iam_role_policy" "main" {
  name = "s3_pubkey_policy"
  role = aws_iam_role.main.id
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
