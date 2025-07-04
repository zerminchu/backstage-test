terraform {
  source = "git::git@sgts.gitlab-dedicated.com:wog/mha/ica-e-services/ica_common_services/app/aws_tg.git//tg-modules//iam-v2"
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  zone_vars = read_terragrunt_config(find_in_parent_folders("zone.hcl"))
  app_vars  = read_terragrunt_config(find_in_parent_folders("app.hcl"))
  env_vars         = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  zone_name  = local.zone_vars.locals.zone_name
  app_name  = local.app_vars.locals.app_name
  env_name         = local.env_vars.locals.env_name

}

inputs = {
  app_name = "${local.env_name}-ecs${local.app_name}taskrole"
  iam_trust_principals = [
    ["Service", ["ecs-tasks.amazonaws.com"]]
  ]

  custom_policies = [
    ["ecsssmpolicy", "ecsssmpolicy.tpl"]
  ]

  arn_policies = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]
}
