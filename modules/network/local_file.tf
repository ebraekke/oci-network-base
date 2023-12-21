###########################################################################
# Parameter file exports
###########################################################################

resource "local_file" "variables_network" {

  content = format("       vcn_ocid = \"%s\"\nlbr_subnet_ocid = \"%s\"\nweb_subnet_ocid = \"%s\"\n db_subnet_ocid = \"%s\"\n", 
                    oci_core_vcn.this.id, oci_core_subnet.lbr.id, oci_core_subnet.web.id, oci_core_subnet.db.id)

  filename = "${var.local_dir_prefix}_network.tfvars"
}
