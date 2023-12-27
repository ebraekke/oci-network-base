
###########################################################################
# Private endpoint(s)
###########################################################################

resource "oci_resourcemanager_private_endpoint" "priv_endpoint" {

    compartment_id = var.compartment_ocid
    display_name   = var.endpoint_name
    subnet_id      = var.subnet_ocid
    vcn_id         = var.vcn_ocid
}
