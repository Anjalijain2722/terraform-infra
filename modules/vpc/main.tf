output "vpc_id" {
  value = aws_vpc.this.id
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
}

output "subnet_ids" {
  value = aws_subnet.this[*].id
}

