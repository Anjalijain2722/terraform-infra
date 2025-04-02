variable "selected_cluster_ids" {
  description = "List of Redis cluster IDs"
  type        = list(string)
}

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
