variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "subnet_id" {}
variable "vnet_id" {}

variable "private_dns_zone_name" {
  type = string
}
variable "subresource_names" {
  type = set(string)
}
variable "resource_id" {}

resource "azurerm_private_dns_zone" "example" {
  # must be fixed string
  # see https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns
  name                = var.private_dns_zone_name
  resource_group_name = var.rg_name
}

# link between zone <-> vnetwork
resource "azurerm_private_dns_zone_virtual_network_link" "example" {
  name                  = "zone-vn-link-${uuid()}"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.example.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_private_endpoint" "example" {
  name                = "endpoint-${uuid()}"
  location            = var.rg_location
  resource_group_name = var.rg_name
  # set privatevm id
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "endpoint-service-connection-${uuid()}"
    # Microsoft.Sql/servers
    private_connection_resource_id = var.resource_id
    is_manual_connection = false
    # see https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview
    subresource_names = var.subresource_names
  }

  # it's necessary
  private_dns_zone_group {
    name                 = "dns-zone-group-${uuid()}"
    private_dns_zone_ids = [azurerm_private_dns_zone.example.id]
  }
}