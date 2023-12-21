output "bastion_ocid" {
  value = module.bastion.bastion_ocid
}

output "lbr_subnet_ocid"  {
  value = module.network.lbr_subnet_ocid
}

output "bastion_subnet_ocid"  {
  value = module.network.bastion_subnet_ocid
}

output "web_subnet_ocid"  {
  value = module.network.web_subnet_ocid
}

output "db_subnet_ocid"  {
  value = module.network.db_subnet_ocid
}
