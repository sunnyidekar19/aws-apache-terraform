resource "random_pet" "main" {}

resource "aws_s3_bucket" "main" {
  acl = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = ""
        sse_algorithm     = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket                  = aws_s3_bucket.main.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_object" "main" {
  bucket                 = aws_s3_bucket.main.id
  key                    = "${var.role}.pub"
  source                 = var.public_key_path
  server_side_encryption = "aws:kms"
}

resource "aws_s3_bucket" "user" {
  bucket = "${random_pet.main.id}-${var.project}"
}
