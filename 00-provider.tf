/*
Copyright 2024 Schwarz IT KG <markus.brunsch@mail.schwarz>

Use of this source code is governed by an MIT-style
license that can be found in the LICENSE file or at
https://opensource.org/licenses/MIT.
*/

# Define required providers
terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.54.1"
    }
    stackit = {
      source = "stackitcloud/stackit"
      version = "0.9.2"
    }
    random = {
      source = "hashicorp/random"
      version = "3.6.0"
    }
  }
}

# Configure the OpenStack Provider
provider "openstack" {
  user_name         = trimspace(var.USERNAME)
  tenant_id         = trimspace(var.TENANTID)
  user_domain_name  = "portal_mvp"
  project_domain_id = "portal_mvp"
  password          = trimspace(var.PASSWORD)
  auth_url          = "https://keystone.api.iaas.eu01.stackit.cloud/v3"
  region            = "RegionOne"
}

provider "stackit" {
  region = "eu01"
  service_account_email = trimspace(var.STACKIT_SERVICE_ACCOUNT_EMAIL)
  service_account_token = trimspace(var.STACKIT_SERVICE_ACCOUNT_TOKEN)
}
