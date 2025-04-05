output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = aws_subnet.public[*].id
}

output "security_group_ids" {
  value = [aws_security_group.vpc_sg.id]
}

