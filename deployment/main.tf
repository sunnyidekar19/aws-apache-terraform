provider "aws" {}

module "vpc" {
  source              = "../resources/network"
  vpc_cidr            = "10.0.0.0/16"
  private_subnet_cidr = "10.0.20.0/24"
  public_subnet_cidr  = "10.0.10.0/24"
}

module "routing" {
  source            = "../resources/routes"
  ig_id             = module.vpc.ig_id
  nat_gw_id         = module.vpc.nat_gw_id
  private_subnet_id = module.vpc.private_subnet_id
  public_subnet_id  = module.vpc.public_subnet_id
  vpc_id            = module.vpc.vpc_id
}