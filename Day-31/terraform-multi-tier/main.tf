provider "aws" {
  region = "us-east-1"
  # profile = "devops-training"
}

module "vpc" {
  source = "./modules/vpc"
  cidr_block          = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  public_subnet_az    = "us-east-1a"
  private_subnet_cidr = "10.0.2.0/24"
  private_subnet_az   = "us-east-1b"
}

module "ec2" {
  source               = "./modules/ec2"
  instance_count       = var.instance_count
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  subnet_id            = module.vpc.public_subnet_id
  iam_instance_profile = module.iam.instance_profile_name
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
}

module "rds" {
  source = "./modules/rds"

  instance_class = var.instance_class
  db_name        = var.db_name
  username       = var.username
  password       = var.password
  subnet_ids     = [module.vpc.public_subnet_id, module.vpc.private_subnet_id]
}

module "iam" {
  source                = "./modules/iam"
  role_name             = var.iam_role_name
  policy_arn            = var.iam_policy_arn
  instance_profile_name = var.iam_instance_profile_name
}