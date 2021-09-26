variable "role" {
  type    = string
  default = "dev"
}

variable "public_key_path" {
  type = string
  description = "The file path for RSA public key"
}