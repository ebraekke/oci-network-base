
###########################################################################
# BASTION host for HA setup
###########################################################################

resource "oci_bastion_bastion" "bastion" {
    name              = "${var.set_name}-bastion" 

    # Required
    bastion_type      = "standard"
    compartment_id    = var.compartment_ocid
    target_subnet_id  = var.subnet_ocid

    # Optional
    client_cidr_block_allow_list  = tolist(["0.0.0.0/0"]) 
    max_session_ttl_in_seconds    = 10800  # 3 hrs
}
