/*
Copyright 2024 Schwarz IT KG <markus.brunsch@mail.schwarz>

Use of this source code is governed by an MIT-style
license that can be found in the LICENSE file or at
https://opensource.org/licenses/MIT.
*/

# OpenStack VM Name
variable "vm_name" {
  type        = string
  description = "VM Name"
  default     = "iCAS"
}

# OpenStack VM Flavor
variable "flavor" {
  type        = string
  description = "VM Flavor"
  default     = "g1.4"
}

# OpenStack Avaliability Zone
variable "availability_zone" {
  type        = string
  description = "VM Availability Zone"
  default     = "eu01-1"
}

# Storage Class for VM Root Volume
variable "root_storage_type" {
  type        = string
  description = "VM Root Volume Storage Type"
  default     = "storage_premium_perf6"
}

# Storage Class for Data Volumes
variable "data_storage_type" {
  type        = string
  description = "VM Data Volume Storage Type"
  default     = "storage_premium_perf4"
}

# Storage Class for Metadata Volumes
variable "metadata_storage_type" {
  type        = string
  description = "VM Metadata Volume Storage Type"
  default     = "storage_premium_perf4"
}

# VM Root Disk size
variable "root_storage_size" {
  type        = number
  description = "VM Root Volume Storage Size"
  default     = 100
}

# Data Disk size
variable "data_storage_size" {
  type        = number
  description = "VM Data Volume Storage Size"
  default     = 1000
}

# Metadata Disk size
variable "metadata_storage_size" {
  type        = number
  description = "VM Metadata Volume Storage Size"
  default     = 500
}

# VPC Network IP Range
variable "lan_netrange" {
  type        = string
  description = "LAN Network Range"
  default     = "10.0.0.0/24"
}

# RDP Access Acl
variable "admin_access_acl" {
  type = map(string)
  default = {
    cidr = "0.0.0.0/0"
  }
}

# Password generator
resource "random_password" "password" {
  length           = 16
  special          = true
  min_lower        = 1
  min_upper        = 1
  min_special      = 1 
  override_special = "!.,"
}

# Do not edit config data
data "template_file" "user_data" {
  template = file("03-user_data")
  vars = {
    icas_config = "${base64encode(data.template_file.config_data.rendered)}",
    admin_passwd = "${random_password.password.result}"
  }
  depends_on = [
    data.template_file.config_data
  ]
}

locals {
  buckets = jsondecode(data.template_file.read_config_data.rendered).Applications.*.Repositoryname
}

output "windows_password" {
  value = nonsensitive(random_password.password.result)
}

data "template_file" "read_config_data" {
  template = file("03-config_data")
  vars = {
    access_key   = "",
    secret_access_key   = ""
  }
}

data "template_file" "config_data" {
  template = file("03-config_data")
  vars = {
    access_key   = "${stackit_objectstorage_credential.icas_creds.access_key}",
    secret_access_key   = "${stackit_objectstorage_credential.icas_creds.secret_access_key}"
  }
  depends_on = [
    stackit_objectstorage_credential.icas_creds
  ]
}
