# public
output "db_fqdn" {
  value = module.mssql.fqdn
}

output "db_private_ip" {
  value = module.endpoint.private_ip
}

output "endpoint_nic_id" {
  value = module.endpoint.nic_id
}


output "vm_user_data" {
  value = base64decode(module.vm1.user_data)
}