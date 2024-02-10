# aks-cluster/variables.tf

variable "aks_cluster_name" {
    description = "the name of the AKS cluster created"
    type        = string
    default     = "terraform-aks-cluster"
    
}

variable "cluster_location" {
    description = "location of the AKS cluster"
    type        = string
    default     = "UK South"
}

variable "dns_prefix" {
    description = "the DNS prefix creates the unique DNS identifier for the cluster"
    type        = string
    default     = "myaks-project"

}

variable "kubernetes_version" {
    description = "version of Kubernetes to be used for the cluster"
    type        = string
    default     = "1.26.6"
}

variable "service_principal_client_id" {
    description = "Client ID of the service principal used for authenticating and managing the AKS cluster"
    type        = string
    default     = "71040ef5-a631-458b-a981-0f37529ec295"

}

variable "service_principal_client_secret" {
    description = "Client Secret associated with the service principal used for AKS cluster authentication"
    type        = string
    default     = "Ndn8Q~OiqE~giRDbI_n4Z3dpcI.uOiKMZyBCTcBU"

}

# Input variables from the networking module

variable "vnet_id" {
  description = "ID of the Virtual Network (VNet)."
  type       = string
  
}

variable "control_plane_subnet_id" {
  description = "ID of the control plane subnet."
  type       = string

}

variable "worker_node_subnet_id" {
  description = "ID of the worker node subnet."
  type        = string

}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group for networking resources."
  type        = string

}

variable "aks_nsg_id" {
  description = "ID of the Network Security Group (NSG) for AKS."
  type        = string


}