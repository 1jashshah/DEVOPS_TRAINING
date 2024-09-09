provider "aws" {
  region = "us-east-1"
  profile = "devops-training"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "tfstate-store-bucket-222"

  tags = {
    Name = "Terraform State Bucket"
  }
}


resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks-222"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "Terraform State Lock Table"
  }
}

output "s3_bucket_name" {
  value = aws_s3_bucket.terraform_state.bucket
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
}

