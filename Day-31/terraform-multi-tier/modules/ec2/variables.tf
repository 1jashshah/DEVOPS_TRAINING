variable "instance_count" {
  description = "Number of EC2 instances"
  type = number
  default = 2
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type = string
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type = string
}

variable "subnet_id" {
  description = "Subnet ID for EC2 instance"
  type = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile for EC2"
  type = string
}