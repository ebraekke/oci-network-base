###########################################################################
# OUTPUT ocids of subnets
###########################################################################
output "lbr_subnet_ocid" {
  value = oci_core_subnet.lbr.id
} 

output "bastion_subnet_ocid" {
  value = oci_core_subnet.bastion.id
} 

output "web_subnet_ocid" {
  value = oci_core_subnet.web.id
} 

output "db_subnet_ocid" {
  value = oci_core_subnet.db.id
} 
