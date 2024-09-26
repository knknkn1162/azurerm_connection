locals {
  nic_ip_configuration_name = "nic-ipconfig"
}

module "bastion" {
  source = "./bastion"
  rg_name = module.resource_group.name
  rg_location = module.resource_group.location
  subnet_id = module.subnets.ids["bastion"]
}

# connection test
module "vm1" {
  source = "./ubuntu_vm"
  os_disk_type = "Standard_LRS"
  spec = "Standard_B2s"
  rg_name = module.resource_group.name
  rg_location = module.resource_group.location
  nic_id = module.nic4vm1.id
  password = var.password
  user_data = local.user_data
}

# The request may be blocked by network rules of storage account.
module "nic4vm1" {
  source = "./nic"
  rg_name = module.resource_group.name
  rg_location = module.resource_group.location
  subnet_id = module.subnets.ids["vm"]
  ip_configuration_name = local.nic_ip_configuration_name
  is_public = false
}

locals {
  user_data = <<-EOF
#!/bin/bash
sudo apt-get update
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
EOF
}

# connection test
module "vm2" {
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
  subnet_id = module.subnets.ids["storage"]
  ip_configuration_name = local.nic_ip_configuration_name
  is_public = false
}