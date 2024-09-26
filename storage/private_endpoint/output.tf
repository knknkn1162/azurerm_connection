output "vm_user_data" {
  value = module.vm1.user_data
}

output "account_fqdn" {
  value = "${module.storage.name}.privatelink.blob.core.windows.net"
}

output "account_key" {
  value = module.storage.key 
  sensitive = true
}

output "connection_string" {
  value = module.storage.connection_string
  sensitive = true
}

locals {
  container_name = "test012345"
  src_file = "/var/log/cloud-init.log"
  directory = "sample01"
}

output "create_container_command" {
  value = <<-EOF
az login
az config set extension.dynamic_install_allow_preview=true 
az storage container create --name ${local.container_name} --connection-string ${module.storage.connection_string}
az storage blob directory upload --account-name ${module.storage.name} --container ${local.container_name} --source ${local.src_file} --destination ${local.directory} --account-key ${module.storage.key}
# check
az storage blob directory list --container-name ${local.container_name} -d ${local.directory} --account-name ${module.storage.name} --account-key ${module.storage.key}
EOF
  sensitive = true
}

output "account_name" {
  value = module.storage.name
}