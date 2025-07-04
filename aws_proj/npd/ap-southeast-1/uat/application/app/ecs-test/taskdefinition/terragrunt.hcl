terraform {

   source = "git::git@sgts.gitlab-dedicated.com:wog/mha/ica-e-services/ica_common_services/app/aws_tg.git//tg-modules//ecs-taskdefinition"
 
}


include "root" {
    path = find_in_parent_folders()
}

dependency "ecsexerole" {
    config_path = "../../../iam/ecsexecutionrole"
}

dependency "taskexerole" {
    config_path = "../iam/ecstaskrole"
}


locals {
    region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
    zone_vars   = read_terragrunt_config(find_in_parent_folders("zone.hcl"))
    acct_vars   = read_terragrunt_config(find_in_parent_folders("account.hcl"))
    proj_vars   = read_terragrunt_config(find_in_parent_folders("common.hcl"))
    env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
    tier_vars   = read_terragrunt_config(find_in_parent_folders("tier.hcl"))
    app_vars    = read_terragrunt_config(find_in_parent_folders("app.hcl"))
    region      = local.region_vars.locals.region
    agency_name = local.acct_vars.locals.agency_name
    proj_code   = local.proj_vars.locals.proj_code
    env_name    = local.env_vars.locals.env_name
    tier_name   = local.tier_vars.locals.tier_name
    app_name    = local.app_vars.locals.app_name
    zone_name   = local.zone_vars.locals.zone_name
    account_ref = local.acct_vars.locals.account_ref
    container_port = local.app_vars.locals.container_port
    image_tag   = "latest"
}


inputs = {
    create_ec2         = false
    family             = "${local.zone_name}${local.app_name}-${local.proj_code}"
    network_mode       = "awsvpc"
    cpu                = "1024"
    memory             = "3072"
    proj_code          = local.proj_code

    execution_role_arn = dependency.ecsexerole.outputs.iamrole_arn
    task_role_arn      = dependency.taskexerole.outputs.iamrole_arn
    task_definition    = "task_definition.tpl" 
        runtime_platform = [
            {
                operating_system_family = "LINUX"
                cpu_architecture        = "X86_64"
            }
        ]
    container = format(
                "ecs-cd-%[1]s%[2]s-%[3]s%[4]s%[5]s-%[6]s",
                local.agency_name,
                local.proj_code,
                local.env_name,
                local.zone_name,
                local.tier_name,
                local.app_name
                ) 
    image        = "${}:${local.image_tag}" # allow backstage to call the image? 
    region       = local.region
    loggroup     = "/ecs/${local.proj_code}/${local.app_name}"
    port_name    = "${local.zone_name}${local.app_name}"
    container_port = local.container_port
}