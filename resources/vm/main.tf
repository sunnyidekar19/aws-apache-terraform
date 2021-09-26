data "aws_ami" "main" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "public" {
  instance_type               = "t2.micro"
  ami                         = data.aws_ami.main.id
  subnet_id                   = var.public_subnet_id
  associate_public_ip_address = true
  security_groups             = [var.public_sg_id]
  key_name                    = "ec2"
  iam_instance_profile        = var.instance_profile_name
  disable_api_termination     = false
  ebs_optimized               = false
  user_data                   = <<-EOF
                  #!/bin/bash
                  useradd ${var.role}
                  usermod -aG wheel ${var.role}
                  mkdir /home/${var.role}/.ssh/
                  aws s3 cp s3://${var.s3_pubkey_bucket_name}/${var.role}.pub /home/${var.role}/.ssh/authorized_keys
                  sudo -i
                  echo “${var.role} ALL=(ALL) NOPASSWD:ALL” >> /etc/sudoers
                  yum update -y
                  EOF
  root_block_device {
    volume_size = "10"
  }
  tags = {
    "Name" = "test-ec2"
  }
}

resource "aws_instance" "private" {
  instance_type           = "t2.micro"
  ami                     = data.aws_ami.main.id
  subnet_id               = var.private_subnet_id
  security_groups         = [var.private_sg_id]
  key_name                = "ec2"
  disable_api_termination = false
  ebs_optimized           = false
  user_data               = <<-EOF
                  #!/bin/bash
                  sudo yum update -y
                  sudo yum -y install httpd
                  echo "<p> My Instance! </p>" >> /var/www/html/index.html
                  sudo systemctl enable httpd
                  sudo systemctl start httpd
                  EOF
  root_block_device {
    volume_size = "10"
  }
  tags = {
    "Name" = "test-ec2-prv"
  }
}
