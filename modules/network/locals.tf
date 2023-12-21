
locals {
    # Network stuff, same sequence as in reference
  bastion_subnet_prefix = cidrsubnet(var.vcn_cidr, var.subnet_cidr_offset, 0)
  db_subnet_prefix      = cidrsubnet(var.vcn_cidr, var.subnet_cidr_offset, 1)
  app_subnet_prefix     = cidrsubnet(var.vcn_cidr, var.subnet_cidr_offset, 2)
  lbr_subnet_prefix     = cidrsubnet(var.vcn_cidr, var.subnet_cidr_offset, 3)

  tcp_protocol          = "6"
  all_protocols         = "all"
  anywhere              = "0.0.0.0/0"
}
