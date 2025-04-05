resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet("10.0.0.0/16", 4, count.index)
  availability_zone = element(["ap-south-1a", "ap-south-1b"], count.index)
}

resource "aws_security_group" "main" {
  vpc_id = aws_vpc.main.id
}


