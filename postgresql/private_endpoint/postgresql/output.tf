output "username" {
  value = azurerm_postgresql_flexible_server.example.administrator_login
}

output "fqdn" {
  value = azurerm_postgresql_flexible_server.example.fqdn
}

output "private_dns_zone_id" {
  value = azurerm_postgresql_flexible_server.example.private_dns_zone_id
}

output "private_ip" {
  value = module.endpoint.private_ip
}

output "nic_id" {
  value = module.endpoint.nic_id
}