output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "ig_id" {
  value = aws_internet_gateway.main.id
}

output "nat_gw_id" {
  value = aws_nat_gateway.main.id
}