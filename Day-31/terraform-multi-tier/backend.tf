terraform {
  backend "s3" {
    bucket         = "tfstate-store-bucket-222" 
    key            = "terraform/state.tfstate"
    region         = "us-east-1" 
    encrypt        = true
    dynamodb_table = "terraform-locks-222" 
  }
}
