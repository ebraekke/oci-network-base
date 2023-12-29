
resource "oci_core_vcn" "this" {
  cidr_block     = var.vcn_cidr
  dns_label      = var.dns_prefix
  compartment_id = var.compartment_ocid
  display_name   = "Network for ${var.dns_prefix}"
}


resource "oci_core_nat_gateway" "nat_gateway" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "nat_gateway"
}

resource "oci_core_internet_gateway" "ig" {  
  compartment_id = var.compartment_ocid
  display_name   = "ig"
  vcn_id         = oci_core_vcn.this.id
}

# LBR
resource "oci_core_route_table" "lbr" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "lbr rt"

  # TODO: Is this correct? 
  route_rules {
    destination       = local.anywhere
    network_entity_id = oci_core_internet_gateway.ig.id
  }
}

resource "oci_core_security_list" "lbr" {
  compartment_id = var.compartment_ocid
  display_name   = "lbr sec list"
  vcn_id         = oci_core_vcn.this.id

  # from Interweb
  dynamic "ingress_security_rules" {
    # http, https
    for_each = [80, 443]
    content {
      source      = local.anywhere
      protocol    = local.tcp_protocol
      description = "${ingress_security_rules.value}: From Interweb to Lbr"

      tcp_options {
        min = ingress_security_rules.value
        max = ingress_security_rules.value
      }
    }
  }

  dynamic "egress_security_rules" {
    # http, https
    for_each = [80, 443]
    content {
      destination = local.app_subnet_prefix
      protocol    = local.tcp_protocol
      description = "${egress_security_rules.value}: From Lbr to App"

      tcp_options {
        min = egress_security_rules.value
        max = egress_security_rules.value
      }
    }

  }
}

resource "oci_core_subnet" "lbr" {
  cidr_block          = local.lbr_subnet_prefix
  display_name        = "lbr subnet"
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_vcn.this.id
  route_table_id      = oci_core_route_table.lbr.id

  security_list_ids = [
    oci_core_security_list.lbr.id,
  ]

  dns_label                  = "lbr"
  prohibit_public_ip_on_vnic = false
}


# BASTION
resource "oci_core_route_table" "bastion" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "bastion rt"

  route_rules {
    destination       = local.anywhere
    network_entity_id = oci_core_internet_gateway.ig.id
  }
}

resource "oci_core_security_list" "bastion" {
  compartment_id = var.compartment_ocid
  display_name   = "bastion sec list"
  vcn_id         = oci_core_vcn.this.id

  # from Interweb
  dynamic "ingress_security_rules" {
    # ssh
    for_each = [22]
    content {
      source      = local.anywhere
      protocol    = local.tcp_protocol
      description = "${ingress_security_rules.value}: From Interweb to Bastion"

      tcp_options {
        min = ingress_security_rules.value
        max = ingress_security_rules.value
      }
    }
  }

  # Rule for managed services
  dynamic "egress_security_rules" {
    # Oracle, MySQL, MongoDB
    for_each = [1521, 3306, 27017]
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

  # Rule for hosts
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

  dns_label                  = "bastion"
  prohibit_public_ip_on_vnic = false
}

resource "oci_core_route_table" "app" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "app rt"

  route_rules {
    destination       = local.anywhere
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat_gateway.id
  }
}


# APP
resource "oci_core_security_list" "app" {
  compartment_id = var.compartment_ocid
  display_name   = "app sec list"
  vcn_id         = oci_core_vcn.this.id

  # from lbr
  dynamic "ingress_security_rules" {
    # http, https
    for_each = [80, 443]
    content {
      source      = local.lbr_subnet_prefix
      protocol    = local.tcp_protocol
      description = "${ingress_security_rules.value}: From Lbr to App"

      tcp_options {
        min = ingress_security_rules.value
        max = ingress_security_rules.value
      }
    }
  }

  # from bastion
  dynamic "ingress_security_rules" {
    # ssh, http, https
    for_each = [22, 80, 443]
    content {
      source   = local.bastion_subnet_prefix
      protocol = local.tcp_protocol
      description = "${ingress_security_rules.value}: From Bastion to App"

      tcp_options {
        min = ingress_security_rules.value
        max = ingress_security_rules.value
      }
    }
  }

  # to DB
  dynamic "egress_security_rules" {
    # Oracle, MySQL, MongoDB 
    for_each = [1521, 3306, 27017]
    content {
      destination = local.db_subnet_prefix
      protocol    = local.tcp_protocol
      description = "${egress_security_rules.value}: From App to Db"

      tcp_options {
        min = egress_security_rules.value
        max = egress_security_rules.value
      }
    }
  }
}

resource "oci_core_subnet" "app" {
  cidr_block          = local.app_subnet_prefix
  display_name        = "app subnet"
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_vcn.this.id
  route_table_id      = oci_core_route_table.app.id

  security_list_ids = [
    oci_core_security_list.app.id,
  ]

  dns_label                  = "app"
  prohibit_public_ip_on_vnic = true
}

# DB
resource "oci_core_route_table" "db" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "db rt"

  route_rules {
    destination       = local.anywhere
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat_gateway.id
  }
}

resource "oci_core_security_list" "db" {
  compartment_id = var.compartment_ocid
  display_name   = "db sec list"
  vcn_id         = oci_core_vcn.this.id

  # from bastion
  dynamic "ingress_security_rules" {
    # Oracle, MySQL, MongoDB
    for_each = [1521, 3306, 27017]
    content {
      source      = local.bastion_subnet_prefix
      protocol    = local.tcp_protocol
      description = "${ingress_security_rules.value}: From Bastion to Db"

      tcp_options {
        min = ingress_security_rules.value
        max = ingress_security_rules.value
      }
    }
  }

  # from app
  dynamic "ingress_security_rules" {
    # Oracle, MySQL, MongoDB
    for_each = [1521, 3306, 27017]
    content {
      source      = local.app_subnet_prefix
      protocol    = local.tcp_protocol
      description = "${ingress_security_rules.value}: From App to Db"

      tcp_options {
        min = ingress_security_rules.value
        max = ingress_security_rules.value
      }
    }
  }

  # within db
  dynamic "ingress_security_rules" {
    # Oracle, MySQL, MongoDB
    for_each = [1521, 3306, 27017]
    content {
      source      = local.db_subnet_prefix
      protocol    = local.tcp_protocol
      description = "${ingress_security_rules.value}: From Db to Db"

      tcp_options {
        min = ingress_security_rules.value
        max = ingress_security_rules.value
      }
    }
  }

}


resource "oci_core_subnet" "db" {
  cidr_block          = local.db_subnet_prefix
  display_name        = "db subnet"
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_vcn.this.id
  route_table_id      = oci_core_route_table.db.id

  security_list_ids = [
    oci_core_security_list.db.id,
  ]

  dns_label                  = "db"
  prohibit_public_ip_on_vnic = true
}
