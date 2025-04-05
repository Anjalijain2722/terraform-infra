resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
   lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = var.vpc_name
  }
}
