module "resource_group" {
    source = "./resource_group"
    location = var.rg_location
}

module "vnetwork" {
    source = "./vnetwork"
    rg_location = module.resource_group.location
    rg_name = module.resource_group.name
    address_space = [var.vnet_cidr]
}


module "subnets" {
  source = "./subnets"
  rg_name = module.resource_group.name
  vn_name = module.vnetwork.name
  label2address_prefixes = {
    "db" = var.db_cidr
    "vm" = var.vm_cidr
    "bastion" = var.bastion_cidr
  }
  service_endpoints = ["Microsoft.Sql"]
}

module "mssql" {
  source = "./mssql"
  rg_location = module.resource_group.location
  rg_name = module.resource_group.name
  db_prefix = var.db_prefix
  db_password = var.db_password
  db_name = var.db_name
  db_version = "12.0"
  subnet_id = module.subnets.ids["db"]
}

# resource "azurerm_mssql_firewall_rule" "example" {
#   name             = "firewall-rule"
#   server_id        = module.mssql.server_id
#   start_ip_address = "0.0.0.0"
#   end_ip_address   = "0.0.0.0"
# }

# for private vm
# module "nat" {
#   source = "./nat"
#   rg_location = module.resource_group.location
#   rg_name = module.resource_group.name
#   subnet_id = module.subnets.ids["vm"]
# }