variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "bucket_name_prefix" {
  description = "Prefix for the S3 bucket name"
  type        = string
  default     = "my-bucket-aws"
}

variable "bucket_name_map" {
  description = "A map of bucket names"
  type        = map(string)
  default     = {
    "prod"    = "prod-bucket"
    "dev"     = "dev-bucket"
    "default" = "default-bucket"
  }
}

variable "bucket_name_key" {
  description = "Key to choose the bucket name from the map"
  type        = string
  default     = "default"
}
