variable "region" {
  description = "AWS region"
  type        = string
}

variable "redis_cluster_id" {
  description = "Redis cluster ID"
  type        = string
}

variable "redis_node_type" {
  description = "Type of Redis node"
  type        = string
}

variable "redis_num_nodes" {
  description = "Number of Redis cache nodes"
  type        = number
}
