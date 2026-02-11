# BASTION
resource "oci_core_route_table" "bastion" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "bastion rt"

  route_rules {
    destination       = local.anywhere
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat_gateway.id
  }
}

resource "oci_core_security_list" "bastion" {
  compartment_id = var.compartment_ocid
  display_name   = "bastion sec list"
  vcn_id         = oci_core_vcn.this.id

/*
  # from internet to bastion => can have bastion node
  dynamic "ingress_security_rules" {
    # ssh
    for_each = [22]
    content {
      source      = local.anywhere
      protocol    = local.tcp_protocol
      description = "${ingress_security_rules.value}: From Internet to Bastion"

      tcp_options {
        min = ingress_security_rules.value
        max = ingress_security_rules.value
      }
    }
  }
*/

  # from bastion service to ctl or service node(s) in the same network
  dynamic "ingress_security_rules" {
    # ssh
    for_each = [22]
    content {
      source      = local.bastion_subnet_prefix
      protocol    = local.tcp_protocol
      description = "${ingress_security_rules.value}: From Bastion to Bastion"

      tcp_options {
        min = ingress_security_rules.value
        max = ingress_security_rules.value
      }
    }
  }

  # Rule for managed services
  dynamic "egress_security_rules" {
    # Oracle, MySQL, InnoDB, MongoDB
    for_each = [22, 1521, 27017, 3306, 33060, 33061]
    content {
      destination = local.db_subnet_prefix
      protocol    = local.tcp_protocol
      description = "${egress_security_rules.value}: From Bastion to Db"

      tcp_options {
        min = egress_security_rules.value
        max = egress_security_rules.value
      }
    }
  }

  # Rule for app hosts
  dynamic "egress_security_rules" {
    # SSH
    for_each = [22]
    content {
      destination = local.app_subnet_prefix
      protocol    = local.tcp_protocol
      description = "${egress_security_rules.value}: From Bastion to App"

      tcp_options {
        min = egress_security_rules.value
        max = egress_security_rules.value
      }
    }
  }

  # Rule for ctl or service hosts
  dynamic "egress_security_rules" {
    # SSH
    for_each = [22]
    content {
      destination = local.bastion_subnet_prefix
      protocol    = local.tcp_protocol
      description = "${egress_security_rules.value}: From Bastion to Bastion"

      tcp_options {
        min = egress_security_rules.value
        max = egress_security_rules.value
      }
    }
  }

  # Rule for egress, needed for self managed nodes
  dynamic "egress_security_rules" {
    # http, https
    for_each = [22, 80, 443]
    content {
      destination = local.anywhere
      protocol    = local.tcp_protocol
      description = "${egress_security_rules.value}: From Bastion to Interweb"

      tcp_options {
        min = egress_security_rules.value
        max = egress_security_rules.value
      }
    }
  }

}

resource "oci_core_subnet" "bastion" {
  cidr_block          = local.bastion_subnet_prefix
  display_name        = "bastion subnet"
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_vcn.this.id
  route_table_id      = oci_core_route_table.bastion.id

  security_list_ids = [
    oci_core_security_list.bastion.id,
  ]

  # TODO: evaluate if this a good idea
  dns_label                  = "bastion"
  prohibit_public_ip_on_vnic = true
}
