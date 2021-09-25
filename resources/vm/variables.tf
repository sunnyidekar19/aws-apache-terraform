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