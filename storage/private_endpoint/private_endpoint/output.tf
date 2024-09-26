output "private_ip" {
  value = azurerm_private_endpoint.example.private_service_connection[0].private_ip_address
}

output "nic_id" {
  value = azurerm_private_endpoint.example.network_interface[0].id
}

output "zone_name" {
  value = azurerm_private_endpoint.example.private_dns_zone_group[0].name
}

output "id" {
  value = azurerm_private_endpoint.example.id
}