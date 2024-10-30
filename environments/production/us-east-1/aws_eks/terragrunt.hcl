include "monolith" {
  path   = find_in_parent_folders("monolith.hcl")
  expose = true
}

terraform {
  source = include.monolith.locals.ic_stack_source
}

dependency "vpc" {
  config_path = "../aws_vpc"
}

inputs = {
  cluster_name = "core-cluster"

  control_plane_subnets = [for k, v in dependency.vpc.outputs.subnet_info : v.subnet_id if strcontains(k, "PUBLIC" )]
}