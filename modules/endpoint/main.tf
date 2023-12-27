
###########################################################################
# Private endpoint
###########################################################################

resource "oci_database_tools_database_tools_private_endpoint" "private_endpoint" {

    compartment_id      = var.compartment_ocid
    display_name        = var.endpoint_name
    endpoint_service_id = local.dbtools_endpoint_ocid 
    subnet_id           = var.subnet_ocid
}
