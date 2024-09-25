variable "rg_location" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "db_prefix" {
  type = string
}

variable "password" {
  type = string
}

variable "db_version" {
  type = string
}
variable "spec" {
  type = string
}
variable "db_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vnet_id" {
  type = string
}

resource "azurerm_postgresql_flexible_server" "example" {
  # should be unique
  name                   = var.db_prefix
  resource_group_name    = var.rg_name
  location               = var.rg_location
  version                = var.db_version
  public_network_access_enabled = false
  administrator_login    = "adminuser"
  administrator_password = var.password
  # If the storage_mb field is undefined on the initial deployment of the PostgreSQL Flexible Server resource it will default to 32768(minimum).
  storage_mb = 32768
  sku_name = var.spec
}

resource "azurerm_postgresql_flexible_server_database" "example" {
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.example.id
}

module "endpoint" {
  source = "../private_endpoint"
  rg_location = var.rg_location
  rg_name = var.rg_name
  vnet_id = var.vnet_id
  subnet_id = var.subnet_id
  private_dns_zone_name = "privatelink.postgres.database.azure.com"
  subresource_names = [ "postgresqlServer"]
  resource_id = azurerm_postgresql_flexible_server.example.id
}