variable "resource_type" {
  description = "Specify the resource to create: vpc or ElastiCache-Redis"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}



