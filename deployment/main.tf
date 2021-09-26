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

module "s3_pubkey" {
  source          = "../resources/s3"
  public_key_path = var.public_key_path
  role            = var.role
}

module "iam" {
  source                = "../resources/iam"
  s3_pubkey_bucket_name = module.s3_pubkey.s3_pubkey_bucket_name
  depends_on            = [module.s3_pubkey]
}

module "ec2" {
  source                = "../resources/vm"
  public_sg_id          = module.routing.public_sg_id
  public_subnet_id      = module.vpc.public_subnet_id
  private_sg_id         = module.routing.private_sg_id
  private_subnet_id     = module.vpc.private_subnet_id
  depends_on            = [module.vpc]
  role                  = var.role
  s3_pubkey_bucket_name = module.s3_pubkey.s3_pubkey_bucket_name
  instance_profile_name = module.iam.instance_profile_name
}
