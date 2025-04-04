variable "resource_type" {
  type    = string
  description = "Resource to create: vpc or redis"
}

variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  type    = string
  default = "my-vpc"
}


variable "redis_cluster_id" {
  type = string
}

variable "redis_node_type" {
  type = string
}

variable "redis_num_nodes" {
  type = number
}
