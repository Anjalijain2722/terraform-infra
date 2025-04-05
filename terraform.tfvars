resource_type = "redis"

vpc_name     = "test-vpc"
vpc_cidr     = "10.0.0.0/16"
subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
azs          = ["ap-south-1a", "ap-south-1b"]

redis_cluster_id = "redis-cluster"
redis_node_type  = "cache.t3.micro"



