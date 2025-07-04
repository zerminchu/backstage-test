terraform {
  source = ""
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  zone_vars = read_terragrunt_config(find_in_parent_folders("zone.hcl"))
  app_vars  = read_terragrunt_config(find_in_parent_folders("app.hcl"))
  app_name  = local.app_vars.locals.app_name
}

inputs = {
        app_name = local.app_name
        log_group_retention = 0
        // cloud_watch_encryption_enabled = false // for ecs:executecommand vapt: to access via "ssh"
}
