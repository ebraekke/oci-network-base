
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
    for_each = [22, 1521, 27017, 3306, 33060, 33061]
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

  # from bastion to PG db
  dynamic "ingress_security_rules" {
    # PG, patroni
    for_each = [22, 6432, 8008]
    content {
      source      = local.bastion_subnet_prefix
      protocol    = local.tcp_protocol
      description = "${ingress_security_rules.value}: From Bastion to PG db"

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
    # SSH, Oracle, MySQL, MongoDB, InnoDB Admin API, MySQL Cluster
    for_each = [22, 1521, 3306, 27017, 33060, 33061]
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

  # within db, autobase
  dynamic "ingress_security_rules" {
    # SSH, etcd 
    for_each = [22, 2379, 2380, 5432, 8008]
    content {
      source      = local.db_subnet_prefix
      protocol    = local.tcp_protocol
      description = "${ingress_security_rules.value}: From PG Db to PG Db"

      tcp_options {
        min = ingress_security_rules.value
        max = ingress_security_rules.value
      }
    }
  }

  # Rule for egress, needed for self managed nodes
  dynamic "egress_security_rules" {
    # http, https
    for_each = [80, 443]
    content {
      destination = local.anywhere
      protocol    = local.tcp_protocol
      description = "${egress_security_rules.value}: From DB to Interweb"

      tcp_options {
        min = egress_security_rules.value
        max = egress_security_rules.value
      }
    }
  }


  # Autobase related + SSH  
  dynamic "egress_security_rules" {
    # SSH, etcd 
    for_each = [22, 2379, 2380, 5432, 8008]
    content {
      destination = local.db_subnet_prefix
      protocol    = local.tcp_protocol
      description = "${egress_security_rules.value}: From PG Db to PG Db"

      tcp_options {
        min = egress_security_rules.value
        max = egress_security_rules.value
      }
    }
  }

  # InnodB Cluster Related + SSH 
  dynamic "egress_security_rules" {
    # Oracle, etcd, MySQL, MongoDB 
    for_each = [22, 3306, 33060, 33061]
    content {
      destination = local.db_subnet_prefix
      protocol    = local.tcp_protocol
      description = "${egress_security_rules.value}: From MysqL Db to MySQL Db"

      tcp_options {
        min = egress_security_rules.value
        max = egress_security_rules.value
      }
    }
  }

}

resource "oci_core_subnet" "db" {
  cidr_block     = local.db_subnet_prefix
  display_name   = "db subnet"
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  route_table_id = oci_core_route_table.db.id

  security_list_ids = [
    oci_core_security_list.db.id,
  ]

  dns_label                  = "db"
  prohibit_public_ip_on_vnic = true
}
