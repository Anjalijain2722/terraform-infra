variable "cluster_id" {
     description = "The ID of the Redis cluster"
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


