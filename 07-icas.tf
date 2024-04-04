/*
Copyright 2024 Schwarz IT KG <markus.brunsch@mail.schwarz>

Use of this source code is governed by an MIT-style
license that can be found in the LICENSE file or at
https://opensource.org/licenses/MIT.
*/

#root Volume
resource "openstack_blockstorage_volume_v3" "root_volume" {
  name              = "iCAS Root Volume"
  description       = "Root Volume Windows Server 2022"
  size              = var.root_storage_size
  image_id          = "3b6a8d96-4488-4a9a-bb2e-8f3aa8da5e47"
  availability_zone = var.availability_zone
  volume_type       = var.root_storage_type
}

# storage volumes
resource "openstack_blockstorage_volume_v3" "tier1" {
  name              = "iCAS-Tier1"
  description       = "iCAS Tier-1 Volume Storage"
  size              = var.data_storage_size
  availability_zone = var.availability_zone
  volume_type       = var.data_storage_type
}

resource "openstack_blockstorage_volume_v3" "metadata1" {
  name              = "iCAS-Metadata1"
  description       = "iCAS Metadata1 Volume Storage"
  size              = var.metadata_storage_size
  availability_zone = var.availability_zone
  volume_type       = var.metadata_storage_type
}

resource "openstack_blockstorage_volume_v3" "metadata2" {
  name              = "iCAS-Metadata2"
  description       = "iCAS Metadata2 Volume Storage"
  size              = var.metadata_storage_size
  availability_zone = var.availability_zone
  volume_type       = var.metadata_storage_type
}

#Coumpute
resource "openstack_compute_instance_v2" "instance" {
  name        = var.vm_name # Server name
  flavor_name = var.flavor
  block_device {
    uuid                  = openstack_blockstorage_volume_v3.root_volume.id
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
  }
  availability_zone = var.availability_zone
  security_groups   = ["iCAS Access", "${openstack_networking_secgroup_v2.icas.id}"]
  user_data         = data.template_file.user_data.rendered
  network {
    port = openstack_networking_port_v2.port.id
  }
  stop_before_destroy = true
  depends_on = [
    stackit_objectstorage_bucket.icas_bucket
  ]
}

resource "openstack_networking_port_v2" "port" {
  name           = "iCAS VM Port"
  network_id     = openstack_networking_network_v2.lan_network.id
  admin_state_up = "true"
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.lan_subnet_1.id
  }
}

# Attach Drive to Server
resource "openstack_compute_volume_attach_v2" "tier1_attach" {
  instance_id = openstack_compute_instance_v2.instance.id
  volume_id   = openstack_blockstorage_volume_v3.tier1.id
}

resource "openstack_compute_volume_attach_v2" "metadata1_attach" {
  instance_id = openstack_compute_instance_v2.instance.id
  volume_id   = openstack_blockstorage_volume_v3.metadata1.id
}

resource "openstack_compute_volume_attach_v2" "metadata2_attach" {
  instance_id = openstack_compute_instance_v2.instance.id
  volume_id   = openstack_blockstorage_volume_v3.metadata2.id
}
