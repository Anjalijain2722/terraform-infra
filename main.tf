# VPC creation
module "vpc" {
  source   = "./modules/vpc"
  count    = lower(var.resource_type) == "vpc" ? 1 : 0
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
}

# Remote VPC state
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "reddis-testing-bucket"
    key    = "vpc/terraform.tfstate"
    region = "ap-south-1"
  }
}

# Conditional logic to get values
locals {
  use_existing_vpc = lower(var.resource_type) == "redis"
  vpc_id           = local.use_existing_vpc ? data.terraform_remote_state.vpc.outputs.vpc_id : (length(module.vpc) > 0 ? module.vpc[0].vpc_id : "")
  subnet_ids       = local.use_existing_vpc ? data.terraform_remote_state.vpc.outputs.subnet_ids : (length(module.vpc) > 0 ? module.vpc[0].subnet_ids : [])
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "your-terraform-state-bucket"
    key    = "vpc/terraform.tfstate" # Make sure this path is correct
    region = "ap-south-1"
    vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  }
}
# Redis module
module "redis" {
  source          = "./modules/redis"
  count           = lower(var.resource_type) == "redis" ? 1 : 0
  cluster_id      = var.redis_cluster_id
  node_type       = var.redis_node_type
  num_cache_nodes = var.redis_num_nodes
  vpc_id          = local.vpc_id
  subnet_ids      = local.subnet_ids
}
