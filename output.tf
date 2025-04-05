output "vpc_vpc_id" {
  value = module.vpc[0].vpc_id
}

output "vpc_subnet_ids" {
  value = module.vpc[0].subnet_ids
}

output "vpc_redis_sg_id" {
  value = module.vpc[0].redis_sg_id
}

