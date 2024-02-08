/*
Copyright 2024 Schwarz IT KG <markus.brunsch@mail.schwarz>

Use of this source code is governed by an MIT-style
license that can be found in the LICENSE file or at
https://opensource.org/licenses/MIT.
*/

# Create vNET Networks
resource "openstack_networking_network_v2" "lan_network" {
  name           = "VPC Network"
  description    = "Local Peering VPC Network"
  admin_state_up = "true"
}

# Create Subnets
resource "openstack_networking_subnet_v2" "lan_subnet_1" {
  name        = "vpc_subnet"
  description = "Local VPC Network"
  network_id  = openstack_networking_network_v2.lan_network.id
  cidr        = var.lan_netrange
  ip_version  = 4
  dns_nameservers = [
    "208.67.222.222",
    "9.9.9.9",
  ]
}

# Create Router with internet access
resource "openstack_networking_router_v2" "lan_router" {
  name                = "lan_router"
  description         = "LAN Router"
  external_network_id = "970ace5c-458f-484a-a660-0903bcfd91ad"
}

# Create Router interfaces
resource "openstack_networking_router_interface_v2" "lan_router_interface_1" {
  router_id = openstack_networking_router_v2.lan_router.id
  subnet_id = openstack_networking_subnet_v2.lan_subnet_1.id
}
