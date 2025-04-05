variable "resource_type" {
  type        = string
  description = "Specify what to deploy: VPC or ElastiCache-Redis"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "ap-south-1"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}


