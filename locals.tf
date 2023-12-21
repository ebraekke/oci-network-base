
# variables for readbility in complex statements
locals {
  # location of outut files
  inventory    = "${path.module}/../0.output"

/*
  # host creation helpers
  ssh_jump_keys = split("\n", file(var.authorized_keys_path)) 
  ssh_key       = var.ssh_public_key

  _cloud_init_plain_bastion = templatefile("${path.module}/templates/bastion.tpl", {ssh_key = local.ssh_key, super_user = var.super_user, ssh_jump_keys = local.ssh_jump_keys})
  user_data_base64_bastion  = base64encode(local._cloud_init_plain_bastion)

  user_data_base64_standard = filebase64("${path.module}/templates/standard.tpl")
*/

  # not used for now, but can be used for distribution across ads
  avadom_list  = data.oci_identity_availability_domains.ads.availability_domains
  avadom_count = length(local.avadom_list)

  # primary domain == ad1
  avadom_name  =  data.oci_identity_availability_domain.ad1.name 

  # fault domains for ad1
  faldom_list  = data.oci_identity_fault_domains.ad1_fds.fault_domains
  faldom_count = length(local.faldom_list)
}
