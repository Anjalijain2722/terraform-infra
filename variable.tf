variable "redis_cluster_id" {}
variable "redis_node_type" {}
variable "redis_num_nodes" {}

variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  default = "my-vpc"
}
