# README.md

+ `azurerm_mssql_server`
  + service endpoint: use public DNS to connect db
    + public_network_access_enabled = true
  + private endpoint: use private DNS to connect db
    + public_network_access_enabled = false
    + private_dns_zone_group is necessary


+ `azurerm_postgresql_flexible_server`
  + Network with private access (virtual network integration): https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-networking-private
    + public_network_access_enabled=false
  + networking with Private Link: https://learn.microsoft.com/ja-jp/azure/postgresql/flexible-server/concepts-networking-private-link
    + public_network_access_enabled=true
    + private_endpoint is necessary

+ `azurerm_account_storage`
  + service_endpoints
    + public_network_access_enabled = true
    + set network_rules.virtual_network_subnet_ids and service_endpoints="Microsoft.Storage"
  + private_endpoint
    + public_network_access_enabled = false
