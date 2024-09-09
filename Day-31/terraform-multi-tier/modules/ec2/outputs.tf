# output "instance_id" {
#   description = "The ID of the EC2 instance"
#   value       = aws_instance.app_server.id
# }

# output "instance_public_ip" {
#   value = aws_instance.app_server.public_ip
# }


output "instance_ids" {
  value = aws_instance.web[*].id
}

output "elastic_ips" {
  value = aws_eip.web[*].public_ip
}