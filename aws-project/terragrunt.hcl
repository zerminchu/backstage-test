# ROOT

# Terragrunt variables from parent files
locals {
  common_vars      = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl", "dont_exist.hcl"), { locals = {} })
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl", "dont_exist.hcl"), { locals = {} })
  zone_vars        = read_terragrunt_config(find_in_parent_folders("zone.hcl", "dont_exist.hcl"), { locals = {} })
  tier_vars        = read_terragrunt_config(find_in_parent_folders("tier.hcl", "dont_exist.hcl"), { locals = {} })
  app_vars         = read_terragrunt_config(find_in_parent_folders("app.hcl", "dont_exist.hcl"), { locals = {} })
  db_vars          = read_terragrunt_config(find_in_parent_folders("database.hcl", "dont_exist.hcl"), { locals = {} })
}

# Global state template
remote_state {
  backend = "s3"
  config = {
    bucket         = "storsvc-s3-${local.account_vars.locals.agency_name}${local.common_vars.locals.proj_code}-${local.environment_vars.locals.env_name}${local.zone_vars.locals.zone_name}na-tfstate"
    key            = "${path_relative_to_include()}/terragrunt_state.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "nosqlsvc-dynamodb-${local.account_vars.locals.agency_name}${local.common_vars.locals.proj_code}-${local.environment_vars.locals.env_name}${local.zone_vars.locals.zone_name}na-tflock"
  }
}

# Map terragrunt variables to terraform input variables (like tfvars)
inputs = merge(
  local.common_vars.locals,
  local.account_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals,
  local.zone_vars.locals,
  local.tier_vars.locals,
  local.app_vars.locals
)

terraform {

}