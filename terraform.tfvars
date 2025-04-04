resource_type       = "vpc" # or "ElastiCache-Redis"
region              = "ap-south-1"
vpc_cidr            = "10.0.0.0/16"
vpc_name            = "my-vpc"

redis_cluster_id    = "my-redis-cluster"
redis_node_type     = "cache.t3.micro"
redis_num_nodes     = 1
