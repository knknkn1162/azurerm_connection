locals {
  nic_ip_configuration_name = "nic-ipconfig"
  private_zone_name = "privatelink.database.windows.net"
  # Public DNS zone forwarders
  public_zone_name = "database.windows.net"
  db_port=1433
}

module "bastion" {
  source = "./bastion"
  rg_name = module.resource_group.name
  rg_location = module.resource_group.location
  subnet_id = module.subnets.ids["bastion"]
}

# connection test
module "vm1" {
  depends_on = [ module.mssql ]
  source = "./ubuntu_vm"
  os_disk_type = "Standard_LRS"
  spec = "Standard_B2s"
  rg_name = module.resource_group.name
  rg_location = module.resource_group.location
  nic_id = module.nic4vm1.id
  password = var.password
  user_data = local.user_data
}

module "nic4vm1" {
  source = "./nic"
  rg_name = module.resource_group.name
  rg_location = module.resource_group.location
  # have to create the same subnet as db
  subnet_id = module.subnets.ids["db"]
  ip_configuration_name = local.nic_ip_configuration_name
  is_public = false
}

locals {
  user_data = <<-EOF
#!/bin/bash
curl https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc
curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list
sudo apt-get update
# install sqlcmd for SQL Server
sudo ACCEPT_EULA=Y apt-get install -y mssql-tools18 unixodbc-dev
echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> /home/${module.mssql.username}/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> /home/${module.mssql.username}/.bashrc
source /home/${module.mssql.username}/.bashrc
# create database; -C: This option is equivalent to the ADO.NET option TRUSTSERVERCERTIFICATE = true
#  To connect to this server, use the Private Endpoint from inside your virtual network 
# (https://docs.microsoft.com/azure/sql-database/sql-database-private-endpoint-overview#how-to-set-up-private-link-for-azure-sql-database).
# /opt/mssql-tools18/bin/sqlcmd -S ${var.db_prefix}.${local.public_zone_name},${local.db_port} -U ${module.mssql.username} -P ${var.db_password} -d ${var.db_name} -C <<-EOT
# test data
# create table person (
# 	id NUMBER PRIMARY KEY,
# 	name VARCHAR2(100)
# );
# go
# EOT
EOF
}


# connection test(failure)
module "vm2" {
  depends_on = [ module.mssql ]
  source = "./ubuntu_vm"
  os_disk_type = "Standard_LRS"
  spec = "Standard_B2s"
  rg_name = module.resource_group.name
  rg_location = module.resource_group.location
  nic_id = module.nic4vm2.id
  password = var.password
  user_data = local.user_data
}

module "nic4vm2" {
  source = "./nic"
  rg_name = module.resource_group.name
  rg_location = module.resource_group.location
  # have to create the same subnet as db
  subnet_id = module.subnets.ids["vm"]
  ip_configuration_name = local.nic_ip_configuration_name
  is_public = false
}