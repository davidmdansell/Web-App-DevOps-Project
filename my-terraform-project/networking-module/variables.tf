# networks/variables.tf

variable "resource_group_name" {
    description = "the name of the resource group in which the AKS cluster will be created"
    type        = string
    default     = "networking-rg"
  
}

variable "location" {
    description = "location of the AKS cluster"
    type        = string
    default     = "UK South"
}

variable "vnet_address_space" {
    description = "address space for the Virtual Network (VNet)"
    type        = list (string)
    default     = ["10.0.0.0/16"]
}
