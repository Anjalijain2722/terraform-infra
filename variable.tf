variable "resource_type" {
  description = "Choose 'vpc' or 'redis'"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
  default     = "my-vpc"
}

variable "redis_cluster_id" {
  description = "Redis cluster ID"
  type        = string
  default     = "redis-cluster"
}

variable "redis_node_type" {
  description = "Node type"
  type        = string
  default     = "cache.t3.micro"
}

variable "redis_num_nodes" {
  description = "Number of Redis nodes"
  type        = number
  default     = 1
}
