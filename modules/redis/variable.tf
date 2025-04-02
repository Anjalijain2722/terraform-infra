variable "cluster_ids" {
  description = "List of available cluster IDs"
  type        = list(string)
  default     = ["redis-cluster", "redis-cluster-1", "redis-cluster-2"]
}
variable "selected_cluster_id" {
  description = "The ID of the selected Redis cluster"
  type        = string
}

variable "node_type" {
    description = "The instance type for Redis nodes"
    type        = string
    default     = "cache.t3.micro"
}
variable "num_cache_nodes" {
    description = "Number of shards in redis cluster node"
    type = number
    default = 2
}


