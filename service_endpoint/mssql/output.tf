output "server_id" {
  value = azurerm_mssql_server.example.id
}

output "fqdn" {
  value = azurerm_mssql_server.example.fully_qualified_domain_name
}

output "username" {
  value = azurerm_mssql_server.example.administrator_login
}