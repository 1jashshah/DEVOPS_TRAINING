resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "main_vpc"
  }
}

resource "aws_subnet" "main_subnet" {
  count = 3
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = element(var.subnet_cidrs, count.index)
  availability_zone = element(["us-east-2a", "us-east-2b", "us-east-2c"], count.index)
}


