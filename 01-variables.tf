/*
Copyright 2024 Schwarz IT KG <markus.brunsch@mail.schwarz>

Use of this source code is governed by an MIT-style
license that can be found in the LICENSE file or at
https://opensource.org/licenses/MIT.
*/

# Project ID
variable "TENANTID" {
  type        = string
  description = "OpenStack Project ID"
}

# UAT Username
variable "USERNAME" {
  type        = string
  description = "UAT Username"
}

# UAT Password
variable "PASSWORD" {
  type        = string
  description = "UAT Password"
}

variable "STACKIT_SERVICE_ACCOUNT_EMAIL" {
  type = string
  description = "STACKIT Service Account Email"
}

variable "STACKIT_SERVICE_ACCOUNT_TOKEN" {
  type = string
  description = "STACKIT Service Account Token"
}

variable "STACKIT_PROJECT_ID" {
  type = string
  description = "STACKIT Project ID"
}