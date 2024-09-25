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
  delegated_subnet_id    = var.subnet_id
  # the private_dns_zone_id is required when setting a delegated_subnet_id
  private_dns_zone_id    = azurerm_private_dns_zone.example.id
  # public_network_access_enabled must be set to false when delegated_subnet_id and private_dns_zone_id have a value.
  public_network_access_enabled = false
  administrator_login    = "adminuser"
  administrator_password = var.password
  # If the storage_mb field is undefined on the initial deployment of the PostgreSQL Flexible Server resource it will default to 32768(minimum).
  storage_mb = 32768
  sku_name = var.spec
  depends_on = [azurerm_private_dns_zone_virtual_network_link.example]
}

resource "azurerm_postgresql_flexible_server_database" "example" {
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.example.id
}

locals {
  # the name can't be the name that you use for one of your Azure Database for PostgreSQL flexible servers
  dns_zone_prefix = "${var.db_prefix}000"
}

resource "azurerm_private_dns_zone" "example" {
  # see https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-networking-private#using-a-private-dns-zone
  # It can not be server name plus zone suffix.
  name                = "${local.dns_zone_prefix}.postgres.database.azure.com"
  resource_group_name = var.rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "example" {
  name                  = "priv-dns-zone-link-${uuid()}"
  private_dns_zone_name = azurerm_private_dns_zone.example.name
  virtual_network_id    = var.vnet_id
  resource_group_name   = var.rg_name
  depends_on            = [var.subnet_id]
}