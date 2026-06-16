data "azurerm_client_config" "current" {}

locals {
  name_prefix = "${var.project}-${var.environment}"
  tags = {
    Project     = "TerraformContainerApps"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = "Azel"
  }
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${local.name_prefix}"
  location = var.location
  tags     = local.tags
}

module "networking" {
  source              = "./modules/networking"
  name_prefix         = local.name_prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.tags
}

module "monitoring" {
  source              = "./modules/monitoring"
  name_prefix         = local.name_prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.tags
}

module "acr" {
  source              = "./modules/container_registry"
  name_prefix         = local.name_prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.tags
}

module "key_vault" {
  source              = "./modules/key_vault"
  name_prefix         = local.name_prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.tags
  tenant_id           = data.azurerm_client_config.current.tenant_id
  deployer_object_id  = data.azurerm_client_config.current.object_id
}

module "identity" {
  source              = "./modules/identity"
  name_prefix         = local.name_prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.tags
  acr_id              = module.acr.acr_id             # ← forces acr before identity
  key_vault_id        = module.key_vault.key_vault_id # ← forces key_vault before identity
}

module "container_apps" {
  source                     = "./modules/container_apps"
  name_prefix                = local.name_prefix
  location                   = var.location
  resource_group_name        = azurerm_resource_group.main.name
  tags                       = local.tags
  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id
  infrastructure_subnet_id   = module.networking.container_apps_subnet_id
  acr_login_server           = module.acr.acr_login_server
  identity_id                = module.identity.identity_id
}