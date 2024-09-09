resource "aws_instance" "k8s_nodes" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  count                  = var.node_count
  subnet_id              = var.subnet_id
  security_groups        = [var.security_group_id]
  iam_instance_profile   = var.instance_profile_name

  tags = {
    Name = "k8s_node-${count.index}"
  }
}
