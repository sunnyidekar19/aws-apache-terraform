variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for VPC"
  #default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  description = "The CIDR block for public subnet in which bastion host will be deployed"
  #default = "10.0.10.0/24"
}

variable "private_subnet_cidr" {
  type        = string
  description = "The CIDR block for private subnet, to host apache web server"
  #default = "10.0.20.0/24"
}

