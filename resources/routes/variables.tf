variable "vpc_id" {
  type        = string
  description = "Resource ID of the VPC"
}

variable "ig_id" {
  type        = string
  description = "Resource ID of the Internet gateway"
}

variable "public_subnet_id" {
  type        = string
  description = "Resource ID of the public subnet"
}

variable "private_subnet_id" {
  type        = string
  description = "Resource ID of the private subnet"
}

variable "nat_gw_id" {
  type        = string
  description = "Resource ID of the NAT gateway"
}