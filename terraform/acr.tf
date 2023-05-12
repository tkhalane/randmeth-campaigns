resource "random_string" "main" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group != "" ? var.resource_group : "${random_string.main.result}"
  location = var.region
}

resource "azurerm_container_registry" "main" {
  name                = var.container_registry_name != "" ? var.container_registry_name : "${random_string.main.result}"
  resource_group_name = azurerm_resource_group.main.name
  admin_enabled       = true
  location            = var.region
  sku                 = "Premium"
}

resource "azurerm_role_assignment" "acrpull_role" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = azuread_service_principal.main.object_id
  depends_on = [
    azurerm_container_registry.main,
    azuread_application.main
  ]
}

resource "azuread_application" "main" {
  # name = azurerm_kubernetes_cluster.main.name
  display_name = azurerm_kubernetes_cluster.main.name
}

resource "azuread_service_principal" "main" {
  application_id               = azuread_application.main.application_id
  app_role_assignment_required = false
}

data "azurerm_subscription" "main" {}

resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = "KUBECONFIG=$PWD/kubeconfig az aks get-credentials --name ${var.cluster_name} --resource-group ${azurerm_resource_group.main.name} --file $PWD/kubeconfig"
  }
  depends_on = [
    azurerm_kubernetes_cluster.main,
  ]
}

resource "null_resource" "destroy-kubeconfig" {
  provisioner "local-exec" {
    when    = destroy
    command = "rm -f $PWD/kubeconfig"
  }
}
