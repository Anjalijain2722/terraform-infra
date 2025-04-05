variable "vpc_name" {}
variable "cidr_block" {}
variable "subnet_cidrs" {
  type = list(string)
}
variable "azs" {
  type = list(string)
}

