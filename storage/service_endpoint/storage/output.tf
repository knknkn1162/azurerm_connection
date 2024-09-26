output "key" {
  value = azurerm_storage_account.example.primary_access_key
}

output "connection_string" {
  value = azurerm_storage_account.example.primary_connection_string
}

output "id" {
  value = azurerm_storage_account.example.id
}