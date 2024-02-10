# variables.tf

variable "client_id" {
  description = "Access key for the provider"
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Secret key for the provider"
    type        = string
    sensitive   = true
}

variable "subscription_id" {
  description = "The subscription ID for the Azure account"
  type        = string
# Remove the "value" attribute from the variable block
# value       = "5668e4c9-8365-4a1a-80b3-233adb861c80"
}

variable "tenant_id" {
  description = "The tenant ID for the Azure account"
  type        = string
# Remove the "value" attribute from the variable block
# value       = "09f5f687-9785-49af-8bf6-aa016870312e"
}

