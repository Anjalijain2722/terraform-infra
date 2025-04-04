variable "resource_type" {
  type        = string
  description = "Type of resource to create: vpc or redis"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}

variable "redis_cluster_id" {
  type        = string
  description = "Redis cluster ID"
}

variable "redis_node_type" {
  type        = string
  description = "Redis node instance type"
}

variable "redis_num_nodes" {
  type        = number
  description = "Number of Redis nodes"
}
