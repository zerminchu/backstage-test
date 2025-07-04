terraform {
    source = "git::git@sgts.gitlab-dedicated.com:wog/mha/ica-e-services/ica_common_services/app/aws_tg.git//tg-modules//ecs-service"
}

include "root" {
    path = find_in_parent_folders()
}

dependency subnetid {
    config_path = "../../../../subnet"
}

dependency taskdefinition_arn {
    config_path = "../taskdefinition"
} 

// dependency targetgrparn {
//     config_path = "../targetgrp"
// }

dependency ecs_sgid {
    config_path = "../secgrp"
}

 dependency ecscluster_id {
     config_path = "../../../cluster"
 }

dependency svc_dis_service {
    config_path = "../../../cloudmap"
}

locals {
    zone_vars   = read_terragrunt_config(find_in_parent_folders("zone.hcl"))
    acct_vars   = read_terragrunt_config(find_in_parent_folders("account.hcl"))
    proj_vars   = read_terragrunt_config(find_in_parent_folders("common.hcl"))
    env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
    tier_vars   = read_terragrunt_config(find_in_parent_folders("tier.hcl"))
    app_vars    = read_terragrunt_config(find_in_parent_folders("app.hcl"))
    agency_name = local.acct_vars.locals.agency_name
    proj_code   = local.proj_vars.locals.proj_code
    env_name    = local.env_vars.locals.env_name
    tier_name   = local.tier_vars.locals.tier_name
    app_name    = local.app_vars.locals.app_name
    zone_name   = local.zone_vars.locals.zone_name
    container_port = local.app_vars.locals.container_port
}

inputs = {
        asg                    = true
        create_ec2             = false
        cluster                = dependency.ecscluster_id.outputs.ecs_cluster_id 
        task_definition_arn    = dependency.taskdefinition_arn.outputs.task_arn
        service_desired_count  = 1
        service_deployment_minimum_healthy_percent = 100
        service_deployment_maximum_percent         = 200
        ecs_subnets            = dependency.subnetid.outputs.subnets_ids  # same networking/ subnet with container instance 
        alarm_names            = dependency.ecscluster_id.outputs.alarm_arn  
        ecs_security_groups    = [dependency.ecs_sgid.outputs.sg_id] 
        capacity_provider_strategy = [
            # {
            #     capacity_provider = "ASG-${local.zone_name}"
            #     weight = 1
            #     base = 1
            # }
        ]

        // associate_alb = true
        // lb_target_groups = [
        //     {
        //         target_container_name = format(
        //         "ecs-cd-%[1]s%[2]s-%[3]s%[4]s%[5]s-%[6]s",
        //         local.agency_name,
        //         local.proj_code,
        //         local.env_name,
        //         local.zone_name,
        //         local.tier_name,
        //         local.app_name
        //         )
        //         container_port = local.container_port
        //         lb_target_group_arn = dependency.targetgrparn.outputs.targetgrp_alb_arn[0]
        //     }
        // ]
        deployment_controller = [
            {
                deployment_type = "ECS"
            }
        ]
        
        // health_check_grace_period_seconds = "60"

        network_mode                = "awsvpc"
        resource_id                 = "service/${dependency.ecscluster_id.outputs.ecs_cluster_name}/ecs-service-m-${local.agency_name}${local.proj_code}-${local.env_name}${local.zone_name}${local.tier_name}-${local.app_name}"   
        ecs_autoscale_max_instances = 2
        ecs_autoscale_min_instances = 1
        target_value                = 75
        service_registries          = [
            {"registry_arn": dependency.svc_dis_service.outputs.namespace_services_arns[0]}
        ]
        // enable_execute_command = true // for ecs:executecommand vapt: to access via "ssh"
}