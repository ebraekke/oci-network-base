
variable "compartment_ocid"   {}
variable "vcn_cidr"           { default = "10.0.0.0/16" }
variable "subnet_cidr_offset" { default = 8 }
variable "local_dir_prefix"   {}
variable "dns_prefix"         {}
