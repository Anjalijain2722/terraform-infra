variable "cluster_id" {
  type        = string
  description = "The ID of the Redis cluster"
}

variable "node_type" {
  type        = string
  description = "The node type for the Redis cluster"
}

variable "num_cache_nodes" {
  type        = number
  description = "The number of Redis nodes"
}

