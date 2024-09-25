# public
output "db_fqdn" {
  value = module.postgresql.fqdn
}

output "vm_user_data" {
  value = module.vm1.user_data
}