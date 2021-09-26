output "bastion_address" {
  value = module.ec2.bastion_address
}

output "webserver_address" {
  value = module.ec2.webserver_address
}

output "s3_pubkey_bucket" {
  value = module.s3.s3_pubkey_bucket_name
}

output "s3_user_bucket" {
  value = module.s3.user_s3_bucket
}