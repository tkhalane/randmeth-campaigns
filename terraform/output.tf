output "cluster_name" {
  value = var.cluster_name
}

output "region" {
  value = var.region
}

output "resource_group" {
  value = var.resource_group
}


output "registry_server" {
  value = azurerm_container_registry.main.login_server
}

output "registry_name" {
  value = azurerm_container_registry.main.name
}
