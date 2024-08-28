# Output EC2 Instance Public IP
output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}

# Output S3 Bucket Name
output "s3_bucket_name" {
  value = aws_s3_bucket.data.bucket
}

# Output Region
output "region" {
  value = var.region
}
