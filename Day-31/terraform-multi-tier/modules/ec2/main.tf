resource "aws_instance" "web" {
  count = var.instance_count
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  associate_public_ip_address = true

  iam_instance_profile = var.iam_instance_profile

  tags = {
    Name = "web-instance-${count.index}"
  }
}

resource "aws_eip" "web" {
  count = var.instance_count
  instance = aws_instance.web[count.index].id
}