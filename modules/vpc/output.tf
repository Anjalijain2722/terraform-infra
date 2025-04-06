output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = aws_subnet.public[*].id
}

output "redis_sg_id" {
  value = aws_security_group.redis_sg.id
}


