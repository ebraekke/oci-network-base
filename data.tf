# Get a list of Availability Domains (ADs)
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# get AD1
data "oci_identity_availability_domain" "ad1" {
    compartment_id = var.tenancy_ocid
    ad_number = "1"
}

# Get FDs in AD1
data "oci_identity_fault_domains" "ad1_fds" {
    availability_domain = data.oci_identity_availability_domain.ad1.name
    compartment_id = var.tenancy_ocid
}
