
# Variables 
variable "set_name" {
    description = "The name of or role of this set, used as base for naming, typicall test/dev/qa"
}

variable "region"               {}

variable "tenancy_ocid"         {}

variable "compartment_ocid"     {
    description = "ocid of compartment"
}

variable "vcn_cidr"           { 
    description = "cidr range for VCN"
    default     = "10.0.0.0/16" 
}

variable "subnet_cidr_offset" { 
    description = "offset or size of subnets"
    default     = 8 
}

###########################################################################
# Details related to account/identity (local_provider.tf) and book keeping
###########################################################################
variable "oci_cli_profile"      { 
    default     = "nosearn" 
    description = "name of oci cli profile used for session based auth"
}
