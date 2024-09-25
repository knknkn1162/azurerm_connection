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
    #"db" = var.db_cidr
    "vm" = var.vm_cidr
    "bastion" = var.bastion_cidr
  }
}

module "db_subnet" {
  source = "./subnets/Microsoft.DBforPostgreSQL/flexibleServers"
  rg_name = module.resource_group.name
  vn_name = module.vnetwork.name
  db_cidr = var.db_cidr
}

module "postgresql" {
  source = "./postgresql"
  rg_location = module.resource_group.location
  rg_name = module.resource_group.name
  spec = "GP_Standard_D2ds_v4"
  password = var.db_password
  db_prefix = var.db_prefix
  db_version = 15
  db_name = var.db_name
  vnet_id = module.vnetwork.id
  subnet_id = module.db_subnet.id
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