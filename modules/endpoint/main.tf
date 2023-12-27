
###########################################################################
# Private endpoint
###########################################################################

resource "oci_database_tools_database_tools_private_endpoint" "private_endpoint" {

    compartment_id      = var.compartment_ocid
    display_name        = var.endpoint_name
    endpoint_service_id = data.oci_database_tools_database_tools_endpoint_services.endpoint_services.database_tools_endpoint_service_collection[0].items[0].id
    subnet_id           = var.subnet_ocid
}
