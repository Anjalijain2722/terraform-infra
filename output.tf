output "vpc_vpc_id" {
  value = length(module.vpc) > 0 ? module.vpc[0].vpc_id : null
}

output "vpc_subnet_ids" {
  value = length(module.vpc) > 0 ? module.vpc[0].subnet_ids : []
}

output "vpc_redis_sg_id" {
  value = length(module.vpc) > 0 ? module.vpc[0].redis_sg_id : null
}
