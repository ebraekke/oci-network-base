
module "network" {
    source              = "./modules/network"

    compartment_ocid    = var.compartment_ocid
    vcn_cidr            = var.vcn_cidr
    subnet_cidr_offset  = var.subnet_cidr_offset
    dns_prefix          = var.set_name
}

module "bastion" {
    source              = "./modules/bastion"
    
    bastion_name        = "${var.set_name}-bastion"
    compartment_ocid    = var.compartment_ocid
    subnet_ocid         = module.network.bastion_subnet_ocid
}
