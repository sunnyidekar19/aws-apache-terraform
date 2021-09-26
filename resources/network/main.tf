resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "vpc-19"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "IG-19"
  }
}

resource "aws_subnet" "private" {
  cidr_block = var.private_subnet_cidr
  vpc_id     = aws_vpc.main.id
  tags = {
    Name = "private-19"
  }
}

resource "aws_subnet" "public" {
  cidr_block = var.public_subnet_cidr
  vpc_id     = aws_vpc.main.id
  tags = {
    Name = "public-19"
  }
}

resource "aws_eip" "main" {
  vpc = true
}

resource "aws_nat_gateway" "main" {
  subnet_id     = aws_subnet.public.id
  allocation_id = aws_eip.main.id
  tags = {
    Name = "Nat-gw"
  }
  depends_on = [aws_internet_gateway.main]
}