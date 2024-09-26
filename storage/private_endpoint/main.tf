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
    "private_link_service" = var.storage_cidr
    "vm" = var.vm_cidr
    "bastion" = var.bastion_cidr
  }
}

module "endpoint" {
  source = "./private_endpoint"
  rg_location = module.resource_group.location
  rg_name = module.resource_group.name
  subnet_id = module.subnets.ids["private_link_service"]
  vnet_id = module.vnetwork.id
  # https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns
  private_dns_zone_name = "privatelink.blob.core.windows.net"
  resource_id = module.storage.id
  # Only one group Id is permitted when connecting to a first-party resource
  subresource_names =  ["blob"]
}

module "storage" {
  source ="./storage"
  prefix = local.storage_prefix
  rg_name = module.resource_group.name
  rg_location = module.resource_group.location
  subnet_id = module.subnets.ids["private_link_service"]
  #endpoint_resource_id = module.vm1.id
}