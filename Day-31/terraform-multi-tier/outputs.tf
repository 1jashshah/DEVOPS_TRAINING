output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  value = module.vpc.private_subnet_id
}

output "instance_ids" {
  value = module.ec2.instance_ids
}

output "elastic_ips" {
  value = module.ec2.elastic_ips
}

output "db_instance_id" {
  value = module.rds.db_instance_id
}

output "bucket_name" {
  value = module.s3.bucket_name
}

output "iam_role_name" {
  value = module.iam.role_name
}

output "iam_instance_profile_name" {
  value = module.iam.instance_profile_name
}