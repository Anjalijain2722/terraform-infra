# outputs.tf (in the root directory)

output "vpc_vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_subnet_ids" {
  value = module.vpc.subnet_ids
}

output "vpc_redis_sg_id" {
  value = module.vpc.redis_sg_id
}
