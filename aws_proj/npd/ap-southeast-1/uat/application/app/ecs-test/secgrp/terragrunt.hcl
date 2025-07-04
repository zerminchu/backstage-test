terraform {
  source = "git::git@sgts.gitlab-dedicated.com:wog/mha/ica-e-services/ica_common_services/app/aws_tg.git//tg-modules//secgrp"
}

include "root" {
  path = find_in_parent_folders()
}


locals {
  zone_vars   = read_terragrunt_config(find_in_parent_folders("zone.hcl"))
  app_vars    = read_terragrunt_config(find_in_parent_folders("app.hcl"))
  app_name    = local.app_vars.locals.app_name
  vpc_subnets_cidr = local.zone_vars.locals.vpc_subnets_cidr
  vpc_id           = local.zone_vars.locals.vpc_id

  inbound_rules = concat(  
    [for cidr in local.vpc_subnets_cidr["app"] : [cidr, "443", "443", "tcp", "app Tier Request HTTP"]],     
    [for cidr in local.vpc_subnets_cidr["app"] : [cidr, "9001", "9001", "tcp", "app Tier Request HTTP"]],
    [for cidr in local.vpc_subnets_cidr["mgt"] : [cidr, "22", "65535", "tcp", "Request to mgt endpoints"]], // for vapt temporary
  )

  outbound_rules = concat(
    [for cidr in local.vpc_subnets_cidr["db"] : [cidr, "3306", "3306", "tcp", "DB tier Request"]],
    [for cidr in local.vpc_subnets_cidr["mgt"] : [cidr, "443", "443", "tcp", "Request to mgt endpoints"]],
  )
}

inputs = {
  sg_description = "Security group for testing ${local.app_name}"
  inbound_rules  = zipmap(range(length(local.inbound_rules)), local.inbound_rules)
  outbound_rules = zipmap(range(length(local.outbound_rules)), local.outbound_rules)
}

