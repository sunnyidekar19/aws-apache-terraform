output "s3_pubkey_bucket_name" {
  value = aws_s3_bucket.main.bucket
}

output "user_s3_bucket" {
  value = aws_s3_bucket.user.bucket
}
