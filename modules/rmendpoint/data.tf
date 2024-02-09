
data "oci_core_subnet" "the_subnet" {
    subnet_id = var.subnet_ocid
}
