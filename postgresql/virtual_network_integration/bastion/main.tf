variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "subnet_id" {
}

module "pip" {
  source = "../pip"
  rg_location = var.rg_location
  rg_name = var.rg_name
}

resource "azurerm_bastion_host" "example" {
  name                = "bastion-${uuid()}"
  location            = var.rg_location
  resource_group_name = var.rg_name
  # Basic sku is default
  # sku = "Basic"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.subnet_id
    public_ip_address_id = module.pip.public_ip_id
  }
}

output "dns_name" {
  value = azurerm_bastion_host.example.dns_name
} 

output "subnet_id" {
  value = azurerm_bastion_host.example.ip_configuration[0].subnet_id
}