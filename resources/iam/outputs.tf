output "bastion_instance_profile" {
  value = aws_iam_instance_profile.bastion.name
}

output "webserver_instance_profile" {
  value = aws_iam_instance_profile.webserver.name
}

output "webserver_read_instance_profile" {
  value = aws_iam_instance_profile.webserver_read.name
}
