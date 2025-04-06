variable "create_vpc" {
  type    = bool
  default = false
}

variable "create_redis" {
  type    = bool
  default = false
}
variable "resource_type" {
  description = "Resource to create - either vpc or redis"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}



