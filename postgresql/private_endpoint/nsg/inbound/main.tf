variable "rg_name" {
    type = string
}

variable "rg_location" {
    type = string
}

variable "dst_ports" {
  type = list(string)
}

variable "subnet_id" {
  type = string
}

resource "azurerm_network_security_group" "example" {
  name                = "nsg-${uuid()}"
  location            = var.rg_location
  resource_group_name = var.rg_name
}

resource "azurerm_network_security_rule" "example" {
  #for_each = {for k, v in var.dst_ports: k+100 => v}
  name                        = "nsr-${uuid()}"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges      = var.dst_ports
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_subnet_network_security_group_association" "http" {
  subnet_id = var.subnet_id
  network_security_group_id = module.azurerm_network_security_group.id
}

output "nsg_id" {
  value = azurerm_network_security_group.example.id
}