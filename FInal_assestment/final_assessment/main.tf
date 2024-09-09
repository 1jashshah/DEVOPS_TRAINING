provider "aws" {
  region     = "us-east-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}


module "vpc" {
  source = "./vpc"
  vpc_cidr_block    = "10.0.0.0/16"
  subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]
}

module "sg" {
  source = "./sg"
  vpc_id = module.vpc.vpc_id
}

module "iam" {
  source = "./iam"
}

module "ec2" {
  source             = "./ec2"
  ami_id             = "ami-085f9c64a9b75eed5" 
  instance_type      = "t2.micro"
  node_count         = 2
  subnet_id          = module.vpc.subnet_ids[0]
  security_group_id  = module.sg.security_group_id
  instance_profile_name = module.iam.instance_profile_name
}

module "s3" {
  source      = "./s3"
  bucket_name = "staticassetsbucket"
}
