
module "network" {
    source              = "./modules/network"

    compartment_ocid    = var.compartment_ocid
    vcn_cidr            = var.vcn_cidr
    subnet_cidr_offset  = var.subnet_cidr_offset
    dns_prefix          = var.set_name
}

## For SSH 
module "bastion" {
    source              = "./modules/bastion"
    
    bastion_name        = "${var.set_name}-bastion"
    compartment_ocid    = var.compartment_ocid
    subnet_ocid         = module.network.bastion_subnet_ocid
}

module "endpoint" {
    source              = "./modules/endpoint"

    endpoint_name       = "${var.set_name}-dbtools-endpoint"
    compartment_ocid    = var.compartment_ocid
    subnet_ocid         = module.network.bastion_subnet_ocid
}

module "rmendpoint" {
    source              = "./modules/rmendpoint"

    rm_endpoint_name    = "${var.set_name}-rmendpoint"
    compartment_ocid    = var.compartment_ocid
    subnet_ocid         = module.network.bastion_subnet_ocid
}
