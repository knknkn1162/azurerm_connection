# README.md

+ `azurerm_mssql_server`
  + service endpoint: use public DNS to connect db
  + private endpoint: use private DNS to connect db
    + private_dns_zone_group is necessary


+ azurerm_postgresql_flexible_server
  + Network with private access (virtual network integration): https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-networking-private
    + public_network_access_enabled=false
  + networking with Private Link: https://learn.microsoft.com/ja-jp/azure/postgresql/flexible-server/concepts-networking-private-link
    + public_network_access_enabled=true + private_endpoint