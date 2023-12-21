
module "network" {
    source              = "./modules/network"

    compartment_ocid    = var.compartment_ocid
    vcn_cidr            = var.vcn_cidr
    subnet_cidr_offset  = var.subnet_cidr_offset
    local_dir_prefix    = "${local.inventory}/${var.set_name}_${var.tenant_short_code}"
    dns_prefix          = var.set_name
}

module "bastion" {
    source              = "./modules/bastion"
    
    set_name            = var.set_name
    compartment_ocid    = var.compartment_ocid
    subnet_ocid         = module.network.bastion_subnet_ocid
}
