# main.tf

provider "aws" {
  region  = "us-east-1" # Specify your AWS region here
  profile = "prod"
}

locals {
  environment = terraform.workspace
}

module "aws_infrastructure" {
  source        = "./modules/aws_infrastructure"
  instance_type = "t2.micro"
  ami_id        = "ami-0e86e20dae9224db8"
  bucket_name   = "jash-bucket-day30-re" # Replace with your S3 bucket name
  environment   = "dev"
}

# main.tf (continued)

resource "remote-exec" "remote_exec" {
  depends_on = [module.aws_infrastructure]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/.my_key_name.pem")
    host        = module.aws_infrastructure.ec2_public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  }
}

# main.tf (continued)

resource "null_resource" "local_exec" {
  depends_on = [null_resource.remote_exec]

  provisioner "local-exec" {
    command = "echo 'EC2 instance successfully provisioned with Apache'"
  }
}


output "ec2_public_ip" {
  value = module.aws_infrastructure.ec2_public_ip
}

output "s3_bucket_arn" {
  value = module.aws_infrastructure.s3_bucket_arn
}

