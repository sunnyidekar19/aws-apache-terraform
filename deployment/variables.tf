variable "role" {
  type        = string
  description = "The role for the user, dev or test"
}

variable "public_key_path" {
  type        = string
  description = "The file path for RSA public key"
}
