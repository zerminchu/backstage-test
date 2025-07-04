terraform {
    source = "git::git@sgts.gitlab-dedicated.com:wog/mha/ica-e-services/ica_common_services/app/aws_tg.git//tg-modules//cloudwatch-loggroup"
}

include "root" {
  path = find_in_parent_folders()
}


locals {
  zone_vars = read_terragrunt_config(find_in_parent_folders("zone.hcl"))
  app_vars  = read_terragrunt_config(find_in_parent_folders("app.hcl"))
  proj_vars   = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  app_name  = local.app_vars.locals.app_name
  proj_code   = local.proj_vars.locals.proj_code

}

inputs = {
  log_group_name  = "/ecs/${local.proj_code}/${local.app_name}"
  log_stream_name = "ecs"
  log_stream      = true

}

