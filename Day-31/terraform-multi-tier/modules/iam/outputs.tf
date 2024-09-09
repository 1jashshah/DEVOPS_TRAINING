output "role_name" {
  value = aws_iam_role.instance_role.name
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.instance_profile.name
}