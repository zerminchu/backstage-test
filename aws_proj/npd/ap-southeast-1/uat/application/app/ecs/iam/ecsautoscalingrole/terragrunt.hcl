terraform {
  source = "git::git@sgts.gitlab-dedicated.com:wog/mha/ica-e-services/ica_common_services/app/aws_tg.git//tg-modules//iam-v2"
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  zone_vars = read_terragrunt_config(find_in_parent_folders("zone.hcl"))
  app_vars = read_terragrunt_config(find_in_parent_folders("app.hcl"))
  zone_name = local.zone_vars.locals.zone_name
  app_name = local.app_vars.locals.app_name
}

inputs = {
  app_name = "${local.app_name}${local.zone_name}autoscalingrole"
  iam_trust_principals = [
    ["Service", ["ecs-tasks.amazonaws.com"]]
  ]
  arn_policies = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
  ]
}
