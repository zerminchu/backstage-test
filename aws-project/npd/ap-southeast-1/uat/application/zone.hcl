locals {
  ############################################################################################
  # ZONE DEFINITIONS
  ############################################################################################
  zone_name = "${{ values.zone_name }}"
  zone_desc = "${{ values.zone_desc }}"

  ############################################################################################
  # PRE-CREATED ON AWS CONSOLE
  ############################################################################################
  vpc_id = "${{ values.vpc_id }}"
  pri_cidr_block = "${{ values.vpc_cidr_block }}"


  ############################################################################################
  # SUBNETS MAPPING & SIZING
  ############################################################################################
  cidr_block  = [local.pri_cidr_block]
  subnets_map = []  # [for subnets_map in ${{ values.subnets_map }} : [ "\"${subnets_map}\"" ]]
  subnets_bits_map = []
  az_list = []

  vpc_subnets_cidr = merge(
    zipmap(local.subnets_map, chunklist(cidrsubnets(local.pri_cidr_block, [for pair in setproduct(local.subnets_bits_map, local.az_list) : pair[0]]...), length(local.az_list))),
  )


  ############################################################################################
  # UNCOMMON VARIABLES
  ############################################################################################
  
}

