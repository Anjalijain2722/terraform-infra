variable "create_vpc" {
  type = bool
}

variable "create_redis" {
  type = bool
}

variable "region" {
  type = string
}

# VPC values (only needed if create_vpc is true)
variable "vpc_name" {
  type    = string
  default = ""
}

variable "vpc_cidr" {
  type    = string
  default = ""
}

# Redis variables
variable "cluster_id" {
  type = string
}

variable "redis_node_type" {
  type = string
}

variable "redis_num_nodes" {
  type = number
}


