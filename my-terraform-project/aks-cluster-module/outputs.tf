# cluster-module/outputs.tf
# # aks-cluster/outputs.tf

# Output the kube_config
output "kube_config" {
  description = "Kube config for connecting to the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
}

# Output aks_cluster_name
output "aks_cluster_name" {
  description = "The name of the AKS cluster created"
  value       = azurerm_kubernetes_cluster.aks_cluster.name
}

# Output aks_cluster_id
output "aks_cluster_id" {
  description = "The ID of the AKS cluster created"
  value       = azurerm_kubernetes_cluster.aks_cluster.id
}

