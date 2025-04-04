provider "aws" {
  region = var.region
}

# VPC Module (runs only if creating vpc)
module "vpc" {
  source   = "./modules/vpc"
  count    = lower(var.resource_type) == "vpc" ? 1 : 0
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
}

# Data source to get vpc_id from existing remote state
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "reddis-testing-bucket"
    key    = "project/infrastructure.tfstate"
    region = "ap-south-1"
  }
}

# Redis Module
module "redis" {
  source = "./modules/redis"
  count  = lower(var.resource_type) == "redis" || lower(var.resource_type) == "ElastiCache-Redis" ? 1 : 0

  cluster_id       = var.redis_cluster_id
  node_type        = var.redis_node_type
  num_cache_nodes  = var.redis_num_nodes
  vpc_id           = var.vpc_id
}

# Error handling: If Redis is selected but no VPC output found
resource "null_resource" "fail_if_no_vpc" {
  count = lower(var.resource_type) == "ElastiCache-Redis" && data.terraform_remote_state.vpc.outputs.vpc_id == "" ? 1 : 0

  provisioner "local-exec" {
    command = "echo 'ERROR: No VPC found. Please create the VPC first using resource_type = vpc' && exit 1"
  }
}

# Output only when VPC is created
output "vpc_id" {
  value = var.resource_type == "vpc" || var.resource_type == "ElastiCache-Redis" ? module.vpc[0].vpc_id : null
}
