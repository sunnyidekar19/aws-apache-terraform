variable "role" {
  type        = string
  description = "The role for the user, dev or test"
}

variable "aws_region" {
  type = string
}

variable "project" {
  type = string
}

variable "owner_email" {
  type = string
}
variable "public_key_path" {
  type        = string
  description = "The file path for RSA public key"
}

variable "aws_keypair" {
  type = string
}
