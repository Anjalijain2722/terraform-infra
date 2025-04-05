variable "aws_region" {
  default = "ap-south-1"
}

variable "resource_type" {
  description = "Type of resource to provision"
  type        = string
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}



