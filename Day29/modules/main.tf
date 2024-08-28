provider "aws" {
  region = var.region
}
# Data Source for AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# Security Group
resource "aws_security_group" "allow_ssh" {
  name        = join("-", ["allow", "ssh", var.instance_type])
  description = "Allow SSH inbound traffic"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  tags = {
    Name = join("-", ["Terraform", "Instance", var.instance_type])
  }

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
}

# S3 Bucket
resource "aws_s3_bucket" "data" {
  bucket = join("-", [var.bucket_name_prefix, lookup(var.bucket_name_map, var.bucket_name_key, "default-bucket")])
}

