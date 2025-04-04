variable "resource" {
  description = "Select which resource to deploy: 'vpc' or 'redis'"
  type        = string
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for Redis"
  default     = []
}
