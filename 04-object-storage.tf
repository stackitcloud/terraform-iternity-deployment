/*
Copyright 2024 Schwarz IT KG <markus.brunsch@mail.schwarz>

Use of this source code is governed by an MIT-style
license that can be found in the LICENSE file or at
https://opensource.org/licenses/MIT.
*/

resource "stackit_objectstorage_bucket" "icas_bucket" {
  for_each   = toset(local.buckets)
  name       = each.value
  project_id = trimspace(var.STACKIT_PROJECT_ID)
  depends_on = [
    data.template_file.config_data
  ]
}

resource "stackit_objectstorage_credential" "icas_creds" {
  project_id = trimspace(var.STACKIT_PROJECT_ID)
  credentials_group_id = stackit_objectstorage_credentials_group.icas_cred_group.credentials_group_id
}

resource "stackit_objectstorage_credentials_group" "icas_cred_group"{
  project_id = trimspace(var.STACKIT_PROJECT_ID)
  name       = "icas"
}