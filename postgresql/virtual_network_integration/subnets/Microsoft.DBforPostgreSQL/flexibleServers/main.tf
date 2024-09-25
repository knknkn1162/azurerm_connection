variable "rg_name" {
  type = string
}

variable "vn_name" {
  type = string
}

variable "db_cidr" {
  type = string
}
# variable "service_endpoints" {
#   type = list(string)
#   default = []
# }

# subnet resources must be created all at once
resource "azurerm_subnet" "example" {
  name = "subnet-${uuid()}"
  resource_group_name = var.rg_name
  virtual_network_name = var.vn_name
  address_prefixes = [var.db_cidr]
  # service_endpoints = var.service_endpoints
  delegation {
    name = "delgation-${uuid()}"
    # az network vnet subnet list-available-delegations --location ${var.rg_location} --query "[?serviceName=='Microsoft.Sql/servers']"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}


output "id" {
  value = azurerm_subnet.example.id
}

output "name" {
  value = azurerm_subnet.example.name
}