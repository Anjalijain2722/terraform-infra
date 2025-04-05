locals {
  create_vpc  = var.resource_type == "vpc"
  create_redis = var.resource_type == "redis"
}

# ✅ Only read remote state if deploying Redis
data "terraform_remote_state" "vpc" {
  count  = local.create_redis ? 1 : 0

  backend = "s3"
  config = {
    bucket = "redis-testing-bucket-new"
    key    = "vpc/terraform.tfstate"
    region = "ap-south-1"
  }
}

module "vpc" {
  source = "./modules/vpc"
  count  = local.create_vpc ? 1 : 0

  # pass any inputs needed
  cidr_block = "10.0.0.0/16"
}

module "redis" {
  source = "./modules/redis"
  count  = local.create_redis ? 1 : 0

  vpc_id = data.terraform_remote_state.vpc[0].outputs.vpc_id
  # other inputs
}
