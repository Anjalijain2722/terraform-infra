terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "redis-testing-bucket-new"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}

provider "aws" {
  region = var.aws_region
}

# ──────────────────────────────
# Create VPC only if resource_type is vpc
# ──────────────────────────────
module "vpc" {
  count          = var.resource_type == "vpc" ? 1 : 0
  source         = "./modules/vpc"
  vpc_cidr_block = var.vpc_cidr_block
}

# ─────────────────────────────────────
# Use Remote State ONLY when Redis needed
# ─────────────────────────────────────
data "terraform_remote_state" "vpc" {
  count = var.resource_type == "redis" ? 1 : 0
  backend = "s3"
  config = {
    bucket = "redis-testing-bucket-new"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}

# ────────────────────────────────
# Validate VPC presence for Redis
# ────────────────────────────────
resource "null_resource" "check_vpc_state" {
  count = var.resource_type == "redis" && length(data.terraform_remote_state.vpc) == 0 ? 1 : 0

  provisioner "local-exec" {
    command = "echo '❌ VPC remote state not found! Redis cannot be provisioned.' && exit 1"
  }
}

# ──────────────────────────────
# Redis Module only if requested
# ──────────────────────────────
module "redis" {
  count              = var.resource_type == "redis" ? 1 : 0
  source             = "./modules/redis"
  vpc_id             = data.terraform_remote_state.vpc[0].outputs.vpc_id
  subnet_ids         = data.terraform_remote_state.vpc[0].outputs.subnet_ids
  security_group_ids = data.terraform_remote_state.vpc[0].outputs.security_group_ids
}
