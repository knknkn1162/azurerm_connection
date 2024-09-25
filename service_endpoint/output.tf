# public
output "db_fqdn" {
  value = module.mssql.fqdn
}

output "vm_user_data" {
  value = module.vm1.user_data
}