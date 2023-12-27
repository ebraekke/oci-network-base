###########################################################################
# OUTPUT ocids of subnets
###########################################################################
output "lbr_subnet_ocid" {
  value = oci_core_subnet.lbr.id
} 

output "bastion_subnet_ocid" {
  value = oci_core_subnet.bastion.id
} 

output "app_subnet_ocid" {
  value = oci_core_subnet.app.id
} 

output "db_subnet_ocid" {
  value = oci_core_subnet.db.id
} 

output "vcn_ocid" {
  value = oci_core_vcn.this.id
}
