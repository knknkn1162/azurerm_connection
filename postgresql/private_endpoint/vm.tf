locals {
  nic_ip_configuration_name = "nic-ipconfig"
  db_port=5432
}

module "bastion" {
  source = "./bastion"
  rg_name = module.resource_group.name
  rg_location = module.resource_group.location
  subnet_id = module.subnets.ids["bastion"]
}

# connection test
module "vm1" {
  depends_on = [ module.postgresql ]
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
  # nic cannot be created in or updated to use the subnet since it has delegation(s) [Microsoft.DBforPostgreSQL/flexibleServer]
  subnet_id = module.subnets.ids["vm"]
  ip_configuration_name = local.nic_ip_configuration_name
  is_public = false
}

locals {
  dns_zone_name = "privatelink.postgres.database.azure.com"
  user_data = <<-EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install -y postgresql-client
# we recommend that you always use an FQDN as the host name when you connect to your Azure Database for PostgreSQL flexible server
PGPASSWORD=${var.db_password} psql -h ${var.db_prefix}.${local.dns_zone_name} -p ${local.db_port} -U ${module.postgresql.username} ${var.db_name}<<-EOT
CREATE TABLE person (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100)
);
insert into person (id, name) VALUES (1, 'Alice');
insert into person (id, name) values (2, 'Bob');
EOT
EOF
}

module "vm2" {
  depends_on = [ module.postgresql ]
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
  subnet_id = module.subnets.ids["private_link_service"]
  ip_configuration_name = local.nic_ip_configuration_name
  is_public = false
}