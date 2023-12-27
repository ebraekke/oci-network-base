
/*

Refer to:
data.oci_database_tools_database_tools_endpoint_services.endpoint_services.database_tools_endpoint_service_collection[0].items[0].id

      + database_tools_endpoint_service_collection = [
          + {
              + items = [
                  + {
                      + compartment_id    = ""
                      + defined_tags      = {}
                      + description       = ""
                      + display_name      = "Database Tools"
                      + freeform_tags     = {}
                      + id                = "ocid1.databasetoolsendpointservice.oc1.eu-stockholm-1.aaaaaaaal3al52lgeuwty6yf6ewexiy3fafr32frjgn5wiboc4hykkkkjdla"
                      + lifecycle_details = ""
                      + name              = "DATABASE_TOOLS"
                      + state             = "ACTIVE"
                      + system_tags       = {}
                      + time_created      = "2022-02-04 19:43:25.44 +0000 UTC"
                      + time_updated      = "2022-02-04 19:43:25.44 +0000 UTC"
                    },
                ]
            },
        ]
      + display_name                               = null
      + filter                                     = null
      + id                                         = "DatabaseToolsDatabaseToolsEndpointServicesDataSource-1806710274"
      + name                                       = null
      + state                                      = null
*/
data "oci_database_tools_database_tools_endpoint_services" "endpoint_services" {
    compartment_id = var.compartment_ocid
}
