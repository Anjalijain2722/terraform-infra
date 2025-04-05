output "vpc_id" {
  value = aws_vpc.this.id
}

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block
}


output "subnet_ids" {
  value = aws_subnet.this[*].id
}

