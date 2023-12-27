
# variables for readbility in complex statements
locals {
    dbtools_endpoint_ocid =  data.oci_database_tools_database_tools_endpoint_services.endpoint_services.database_tools_endpoint_service_collection[0].items[0].id
}
