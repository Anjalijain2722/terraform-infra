provider "aws" {
  region = var.region
}

locals {
  is_vpc   = var.resource_type == "VPC"
  is_redis = var.resource_type == "ElastiCache-Redis"
}

# VPC Module (provision only if creating VPC)
module "vpc" {
  count  = local.is_vpc ? 1 : 0
  source = "./modules/vpc"
  region = var.region
}

# Load VPC from remote state (used only when provisioning Redis)
data "terraform_remote_state" "vpc" {
  count = local.is_redis ? 1 : 0
  backend = "s3"
  config = {
    bucket = "redis-testing-bucket-new"
    key    = "vpc/terraform.tfstate"
    region = var.region
  }
}

# Redis Module (uses remote VPC data)
module "redis" {
  count      = local.is_redis ? 1 : 0
  source     = "./modules/redis"
  region     = var.region

  vpc_id     = data.terraform_remote_state.vpc[0].outputs.vpc_id
  subnet_ids = data.terraform_remote_state.vpc[0].outputs.subnet_ids
  sg_id      = data.terraform_remote_state.vpc[0].outputs.redis_sg_id
}

# Optional: Validate VPC exists when provisioning Redis
resource "null_resource" "validate_remote_vpc" {
  count = local.is_redis && (
    data.terraform_remote_state.vpc[0].outputs.vpc_id == "" ||
    length(data.terraform_remote_state.vpc[0].outputs.subnet_ids) == 0 ||
    data.terraform_remote_state.vpc[0].outputs.redis_sg_id == ""
  ) ? 1 : 0

  provisioner "local-exec" {
    command = "echo '❌ ERROR: Required VPC outputs not found in remote state.' && exit 1"
  }
}
