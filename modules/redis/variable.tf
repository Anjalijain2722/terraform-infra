variable "resource_type" {
  description = "Type of resource to create, like ElasticCache-Redis or vpc"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for Redis"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for Redis"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security Group IDs for Redis"
  type        = list(string)
}

