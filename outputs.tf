output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "container_apps_subnet_id" {
  value = module.networking.container_apps_subnet_id
}

output "container_app_url" {
  value = "https://${module.container_apps.container_app_fqdn}"
}