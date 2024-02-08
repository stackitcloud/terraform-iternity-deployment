/*
Copyright 2024 Schwarz IT KG <markus.brunsch@mail.schwarz>

Use of this source code is governed by an MIT-style
license that can be found in the LICENSE file or at
https://opensource.org/licenses/MIT.
*/

# Create iCAS Security Group
resource "openstack_networking_secgroup_v2" "icas" {
  name        = "iCAS Access"
  description = "Allow needed Connections"
}

# Add RDP Access Rule
resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_rdp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 3389
  port_range_max    = 3389
  remote_ip_prefix  = var.admin_access_acl["cidr"]
  security_group_id = openstack_networking_secgroup_v2.icas.id
}
