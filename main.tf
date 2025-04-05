terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# 🔍 Read VPC state from remote backend
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "redis-testing-bucket-new"
    key    = "vpc/terraform.tfstate"  # Update this path if different
    region = "ap-south-1"
  }
}

# 🧠 Conditional logic for Redis
module "redis" {
  count           = var.create_redis && !var.create_vpc ? 1 : 0
  source          = "./modules/redis"
  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids      = data.terraform_remote_state.vpc.outputs.subnet_ids
  cluster_id      = var.cluster_id
  redis_node_type = var.redis_node_type
  redis_num_nodes = var.redis_num_nodes
}
