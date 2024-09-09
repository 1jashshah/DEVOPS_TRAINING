variable "ami_id" {
  description = "The ID of the AMI to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
}

variable "node_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 1
}

variable "subnet_id" {
  description = "The VPC subnet ID to launch the instance in"
  type        = string
}

variable "security_group_id" {
  description = "The security group ID to associate with the instance"
  type        = string
}

variable "instance_profile_name" {
  description = "The name of the IAM instance profile to associate with the instance"
  type        = string
}
