provider "aws" {
  default_tags {
    tags = {
      Region  = var.aws_region
      Project = var.project
      Role    = var.role
      Owner   = var.owner_email
    }
  }
}

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

module "s3" {
  source          = "../resources/s3"
  public_key_path = var.public_key_path
  role            = var.role
  project         = var.project
}

module "iam" {
  source                = "../resources/iam"
  s3_pubkey_bucket_name = module.s3.s3_pubkey_bucket_name
  user_s3_bucket        = module.s3.user_s3_bucket
  depends_on            = [module.s3]
}

module "ec2" {
  source                      = "../resources/vm"
  public_sg_id                = module.routing.public_sg_id
  public_subnet_id            = module.vpc.public_subnet_id
  private_sg_id               = module.routing.private_sg_id
  private_subnet_id           = module.vpc.private_subnet_id
  role                        = var.role
  s3_pubkey_bucket_name       = module.s3.s3_pubkey_bucket_name
  bastion_instance_profile    = module.iam.bastion_instance_profile
  webserver_read_profile_name = module.iam.webserver_read_instance_profile
  webserver_profile_name      = module.iam.webserver_instance_profile
  aws_keypair                 = var.aws_keypair
  project                     = var.project
  depends_on                  = [module.vpc]
}
