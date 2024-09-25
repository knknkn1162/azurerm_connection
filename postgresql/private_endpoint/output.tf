# public
output "db_fqdn" {
  value = module.postgresql.fqdn
}

output "db_private_ip" {
  value = module.postgresql.private_ip
}

output "vm_user_data" {
  value = module.vm1.user_data
}