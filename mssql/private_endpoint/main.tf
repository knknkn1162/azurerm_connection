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
    "vm" = var.vm_cidr
    "private_link_service" = var.db_cidr
    "bastion" = var.bastion_cidr
  }
}

module "mssql" {
  source = "./private_mssql"
  rg_location = module.resource_group.location
  rg_name = module.resource_group.name
  db_prefix = var.db_prefix
  db_password = var.db_password
  db_name = var.db_name
  db_version = "12.0"
}

module "endpoint" {
  source = "./private_endpoint"
  rg_name = module.resource_group.name
  rg_location = module.resource_group.location
  vnet_id = module.vnetwork.id
  subnet_id = module.subnets.ids["private_link_service"]
  private_dns_zone_name = local.private_zone_name
  resource_id = module.mssql.server_id
  subresource_names = [ "sqlServer" ]
}

# for private vm
# module "nat" {
#   source = "./nat"
#   rg_location = module.resource_group.location
#   rg_name = module.resource_group.name
#   subnet_id = module.subnets.ids["vm"]
# }

