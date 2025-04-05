variable "resource_type" {}
variable "vpc_name" {}
variable "vpc_cidr" {}
variable "subnet_cidrs" {
  type = list(string)
}
variable "azs" {
  type = list(string)
}

variable "redis_cluster_id" {}
variable "redis_node_type" {}




