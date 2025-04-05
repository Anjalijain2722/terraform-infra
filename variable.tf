variable "redis_cluster_id" {}
variable "redis_node_type" {}
variable "redis_num_nodes" {}

variable "region" {
  default = "ap-south-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  default = "my-vpc"
}

variable "resource_type" {
  description = "Type of resource to provision: vpc or redis"
  type        = string
}

variable "create_vpc" {
  description = "Whether to create VPC"
  type        = bool
  default     = false
}

variable "create_redis" {
  description = "Whether to create Redis"
  type        = bool
  default     = false
}

