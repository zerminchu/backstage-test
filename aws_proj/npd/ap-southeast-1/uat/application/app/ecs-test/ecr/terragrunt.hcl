terraform {
  source = "git::git@sgts.gitlab-dedicated.com:wog/mha/ica-e-services/ica_common_services/app/aws_tg.git//tg-modules//ecr-v2"
}

include "root" {
  path = find_in_parent_folders()
}

dependency "iamecsexe" {
  config_path = "../../../iam/ecsexecutionrole"
}

dependency "iamecstask" {
  config_path = "../iam/ecstaskrole"
}

locals {
  app_vars = read_terragrunt_config(find_in_parent_folders("app.hcl"))
  app_name = local.app_vars.locals.app_name
}

inputs = {
  iam_roles = "\"${dependency.iamecsexe.outputs.iamrole_arn}\",\"${dependency.iamecstask.outputs.iamrole_arn}\""

  ecr_list = {
    "0" = [local.app_name, "MUTABLE", true, true]
  }
}
