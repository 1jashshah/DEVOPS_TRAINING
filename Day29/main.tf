terraform {
  backend "s3" {
    bucket         = "jash-application-bucket"   # Replace with your S3 bucket name
    key            = "terraform/state.tfstate"         # Path within the bucket
    region         = "us-west-2"                       # AWS region
    dynamodb_table = "jash-terraform-lock-table"      # DynamoDB table for locking
  }
}

provider "aws" {
  region = "us-west-2"  # Replace with your AWS region
}

module "jash_app" {
  source                = "./modules/app"
  region                = "ap-south-1"  # Replace with your AWS region
  instance_type         = "t2.micro"
  bucket_name           = "jash-application-bucket"  # Replace with a unique bucket name
  dynamodb_table_name   = "jash-terraform-lock-table"  # Replace with a unique table name
  vpc_id                = "vpc-0ff168e1592fc276a"
  availability_zone     = "ap-south-1a"
  ami_id                = "ami-0522ab6e1ddcc7055"  # Replace with the AMI ID for your region
}

output "instance_public_ip" {
  value = module.jash_app.instance_public_ip
}

output "bucket_name" {
  value = module.jash_app.bucket_name
}

output "dynamodb_table_name" {
  value = module.jash_app.dynamodb_table_name
}
