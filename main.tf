module "vpc" {
  count  = var.resource_type == "vpc" ? 1 : 0
  source = "./modules/vpc"
}

module "redis" {
  count               = var.resource_type == "ElastiCache-Redis" ? 1 : 0
  source              = "./modules/redis"
  vpc_id              = module.vpc[0].vpc_id
  subnet_ids          = module.vpc[0].subnet_ids
  security_group_ids  = module.vpc[0].security_group_ids
  resource_type       = var.resource_type
}


