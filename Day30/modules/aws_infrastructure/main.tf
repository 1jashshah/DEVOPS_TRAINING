# modules/aws_infrastructure/main.tf

# EC2 instance resource
resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

// Create Key Pair for Connecting EC2 via SSH
resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

// Save PEM file locally
resource "local_file" "private_key" {
  content  = tls_private_key.rsa_4096.private_key_pem
  filename = var.key_name

  provisioner "local-exec" {
    command = "chmod 400 ${var.key_name}"
  }
}

# EC2 Instance
resource "aws_instance" "app" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name = aws_key_pair.key_pair.key_name
  associate_public_ip_address = true
  tags = {
    Name = "jash-instance"
  }
}
# S3 bucket resource
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags = {
    Name        = "S3-${var.environment}"
    Environment = var.environment
  }
}
