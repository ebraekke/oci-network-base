
resource "oci_resourcemanager_private_endpoint" "rm_private_endpoint" {
    compartment_id  = var.compartment_ocid
    display_name    = var.rm_endpoint_name
    subnet_id       = var.subnet_ocid
    vcn_id          = data.oci_core_subnet.the_subnet.vcn_id
}

