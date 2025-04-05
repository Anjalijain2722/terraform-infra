output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = [for subnet in aws_subnet.public : subnet.id]
}

output "redis_sg_id" {
  value = aws_security_group.redis_sg.id
}
