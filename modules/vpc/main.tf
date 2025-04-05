resource "aws_subnet" "this" {
  count             = 2
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  availability_zone = element(["ap-south-1a", "ap-south-1b"], count.index)
}

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block
}
