variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "resource_type" {
  description = "Choose which resource to create (vpc or redis)"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}




