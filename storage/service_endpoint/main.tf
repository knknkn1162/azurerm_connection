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
    "storage" = var.storage_cidr
    "vm" = var.vm_cidr
    "bastion" = var.bastion_cidr
  }
  # do not have ServiceEndpoints for Microsoft.Storage resources configured. 
  # Add Microsoft.Storage to subnet's ServiceEndpoints collection before trying to ACL Microsoft.Storage resources to these subnets
  service_endpoints = ["Microsoft.Storage"]
}

module "storage" {
  source ="./storage"
  prefix = local.storage_prefix
  rg_name = module.resource_group.name
  rg_location = module.resource_group.location
  subnet_id = module.subnets.ids["storage"]
}