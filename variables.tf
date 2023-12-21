
# Input variables
variable "vcn_cidr"           { 
    description = "cidr range for VNC"
    default     = "10.0.0.0/16" 
}

variable "subnet_cidr_offset" { 
    description = "offset or size of subnets"
    default     = 8 
}

###########################################################################
# Used for naming output files and objects, incl. for ansible
###########################################################################
variable "tenant_short_code"    {
    description = "alias of the tenant"
}
variable "set_name"             {
    description = "name of set"
}

###########################################################################
# Details related to account/identity (provider.tf)
###########################################################################
variable "oci_cli_profile"  { default = "nosearn" }
variable "region"           { default = "eu-stockholm-1" }
variable "tenancy_ocid"     {}
variable "compartment_ocid" {}
