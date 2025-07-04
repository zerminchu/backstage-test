terraform {
  source = "git::git@sgts.gitlab-dedicated.com:wog/mha/ica-e-services/ica_common_services/app/aws_tg.git//tg-modules//iam-v2"
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  zone_vars = read_terragrunt_config(find_in_parent_folders("zone.hcl"))
  zone_name = local.zone_vars.locals.zone_name
}

inputs = {
  app_name = "ecs${local.zone_name}${iam_resource_name}role"

  arn_policies = []

  iam_trust_principals = []

  custom_policies = []
}