variable "subnet_ids" {
  type = list(string)
  description = "Subnet IDs to launch Redis cluster"
}

variable "vpc_id" {
  description = "VPC ID (must exist)"
  type        = string
}
