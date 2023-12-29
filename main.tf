
module "network" {
    source              = "./modules/network"

    compartment_ocid    = var.compartment_ocid
    vcn_cidr            = var.vcn_cidr
    subnet_cidr_offset  = var.subnet_cidr_offset
    dns_prefix          = var.set_name
}

## For SSH 
module "ext-bastion" {
    source              = "./modules/bastion"
    
    bastion_name        = "${var.set_name}-bastion-ext"
    compartment_ocid    = var.compartment_ocid
    subnet_ocid         = module.network.bastion_subnet_ocid
}

## For use with OCI Console
module "int-bastion" {
    source              = "./modules/bastion"
    
    bastion_name        = "${var.set_name}-bastion-int"
    compartment_ocid    = var.compartment_ocid
    subnet_ocid         = module.network.db_subnet_ocid
}

module "endpoint" {
    source              = "./modules/endpoint"

    endpoint_name       = "${var.set_name}-dbtools-endpoint"
    compartment_ocid    = var.compartment_ocid
    subnet_ocid         = module.network.db_subnet_ocid
}
