
resource "azurerm_mssql_server" "example" {
  name                         = var.db_prefix
  resource_group_name          = var.rg_name
  location                     = var.rg_location
  version                      = var.db_version
  administrator_login          = "adminuser"
  administrator_login_password = var.db_password
  minimum_tls_version          = "Disabled"
  public_network_access_enabled = false
}

resource "azurerm_mssql_database" "example" {
  name           = var.db_name
  server_id      = azurerm_mssql_server.example.id
  collation      = "SQL_Latin1_General_CP1_CI_AI"
  # prevent the possibility of accidental data loss
  #lifecycle {
  #  prevent_destroy = true
  #}
}