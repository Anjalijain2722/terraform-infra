variable "resource_type" {
  type = string
  description = "Resource to create: vpc or redis"

  validation {
    condition     = contains(["vpc", "redis"], lower(var.resource_type))
    error_message = "resource_type must be either 'vpc' or 'redis'"
  }
}
