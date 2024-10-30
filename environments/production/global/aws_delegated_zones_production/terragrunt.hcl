include "monolith" {
  path   = find_in_parent_folders("monolith.hcl")
  expose = true
}

terraform {
  source = include.monolith.locals.ic_stack_source
}

dependency "root_domains" {
  config_path = "../aws_registered_domains"
}

inputs = {
  root_domain_names     = keys(dependency.root_domains.outputs.domains)
  zones                 = dependency.root_domains.outputs.zones
  subdomain_identifiers = ["prod"]
}
