output "bastion_address" {
  value = aws_instance.public.public_ip
}

output "webserver_address" {
  value = aws_instance.private.private_ip
}
