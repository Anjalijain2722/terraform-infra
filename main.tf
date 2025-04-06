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

# Load VPC from remote state only when provisioning Redis
data "terraform_remote_state" "vpc" {
  count  = local.is_redis ? 1 : 0
  backend = "s3"
  config = {
    bucket = "redis-testing-bucket-new"
    key    = "vpc/terraform.tfstate"
    region = var.region
  }
}

# Extract values only if remote state is loaded
locals {
  vpc_id      = local.is_redis && data.terraform_remote_state.vpc[0] != null ? try(data.terraform_remote_state.vpc[0].outputs.vpc_vpc_id, null) : null
  subnet_ids  = local.is_redis && data.terraform_remote_state.vpc[0] != null ? try(data.terraform_remote_state.vpc[0].outputs.vpc_subnet_ids, []) : []
  redis_sg_id = local.is_redis && data.terraform_remote_state.vpc[0] != null ? try(data.terraform_remote_state.vpc[0].outputs.vpc_redis_sg_id, null) : null
}

# Redis Module (uses remote VPC data)
module "redis" {
  count      = local.is_redis ? 1 : 0
  source     = "./modules/redis"
  region     = var.region

  vpc_id     = local.vpc_id
  subnet_ids = local.subnet_ids
  sg_id      = local.redis_sg_id
}

output "debug_subnet_ids" {
  value = local.subnet_ids
}

# Optional: Validate VPC exists when provisioning Redis
resource "null_resource" "validate_remote_vpc" {
  count = local.is_redis && (
    local.vpc_id == null ||
    length(local.subnet_ids) == 0 ||
    local.redis_sg_id == null
  ) ? 1 : 0

  provisioner "local-exec" {
    command = "echo '❌ ERROR: Required VPC outputs not found in remote state.' && exit 1"
  }
}
