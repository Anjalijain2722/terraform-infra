variable "resource_type" {
  type = string
}
variable "vpc_cidr_block" {
  type        = string
  description = "CIDR for the VPC"
}
output "redis_sg_id" {
  value = aws_security_group.redis_sg.id
}
