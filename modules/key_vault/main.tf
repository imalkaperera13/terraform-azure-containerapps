

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_key_vault" "main" {
  name                       = "kv-${var.name_prefix}-${random_string.suffix.result}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = var.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = true # was: enable_rbac_authorization
  soft_delete_retention_days = 7
  purge_protection_enabled   = false # true in prod; false here for easy cleanup
  tags                       = var.tags
}

# Let the deployer (you) manage secrets via RBAC
resource "azurerm_role_assignment" "deployer_secrets" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = var.deployer_object_id
}

resource "azurerm_key_vault_secret" "sample" {
  name         = "sample-app-secret"
  value        = var.sample_secret_value
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_role_assignment.deployer_secrets] # role must exist before writing
}