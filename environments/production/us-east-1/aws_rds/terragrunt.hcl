include "monolith" {
    path   = find_in_parent_folders("monolith.hcl")
    expose = true
}

terraform {
    source = include.monolith.locals.ic_stack_source
}

dependency "aws_vpc" {
    config_path = "../aws_vpc"
}

inputs = {
    public_subnet_ids = [for k, v in dependency.aws_vpc.outputs.subnet_info : v.subnet_id if strcontains(k, "PUBLIC" )]
    vpc_id     = dependency.aws_vpc.outputs.vpc_id
    vpc_cidr  = dependency.aws_vpc.outputs.vpc_cidr
}