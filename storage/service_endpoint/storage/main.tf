variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "prefix" {
  type = string
}

resource "azurerm_storage_account" "example" {
  name                = var.prefix
  resource_group_name = var.rg_name
  location = var.rg_location
  account_tier = "Standard"
  account_replication_type = "LRS"
  # defaults: true
  # true when "Enabled from selected virtual networks and IP addresses"
  # public_network_access_enabled = true
}

module "random" {
  source = "../../../lib/random_string"
  length = 12
}

# make sure that public_network_access_enabled=true
resource "azurerm_storage_container" "example" {
  name                  = "sc${module.random.res}"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}

resource "azurerm_storage_account_network_rules" "example" {
  depends_on = [ azurerm_storage_container.example ]
  storage_account_id = azurerm_storage_account.example.id
  default_action             = "Deny"
  virtual_network_subnet_ids = [var.subnet_id]
  # ip_rules: List of public IP or IP ranges in CIDR Format.
  # bypass: Defaults to ["AzureServices"].
}