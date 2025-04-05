resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_subnet" "public" {
  count                   = 2
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  vpc_id                  = aws_vpc.main.id
  availability_zone       = element(["ap-south-1a", "ap-south-1b"], count.index)
  map_public_ip_on_launch = true
}

resource "aws_security_group" "vpc_sg" {
  vpc_id = aws_vpc.main.id
}



