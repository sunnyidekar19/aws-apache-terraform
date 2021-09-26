variable "public_subnet_id" {
  type        = string
  description = "The Resource ID for the public subnet"
}

variable "public_sg_id" {
  type        = string
  description = "The Resource ID for the public security group"
}

variable "private_subnet_id" {
  type        = string
  description = "The Resource ID for the private subnet"
}

variable "private_sg_id" {
  type        = string
  description = "The Resource ID for the private security group"
}

variable "role" {
  type        = string
  description = "The role of the user"
}

variable "s3_pubkey_bucket_name" {
  type = string
}

variable "webserver_profile_name" {
  type = string
}

variable "webserver_read_profile_name" {
  type = string
}

variable "bastion_instance_profile" {
  type = string
}
