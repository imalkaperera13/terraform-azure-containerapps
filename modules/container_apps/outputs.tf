output "container_app_fqdn" { value = azurerm_container_app.main.ingress[0].fqdn }
output "container_app_environment_id" { value = azurerm_container_app_environment.main.id }