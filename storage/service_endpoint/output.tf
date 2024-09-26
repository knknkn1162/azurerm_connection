output "vm_user_data" {
  value = module.vm1.user_data
}

output "account_key" {
  value = module.storage.key 
  sensitive = true
}

output "connection_string" {
  value = module.storage.connection_string
  sensitive = true
}

output "create_container_command" {
  value = "az storage container create --name test1234 --connection-string ${module.storage.connection_string}"
}