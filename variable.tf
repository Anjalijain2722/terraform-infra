variable "resource_type" {
  description = "Resource type to provision"
  type        = string
}


variable "create_vpc" {
  description = "Whether to create VPC"
  type        = bool
}

variable "create_redis" {
  description = "Whether to create Redis"
  type        = bool
}

variable "cluster_id" {}
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


