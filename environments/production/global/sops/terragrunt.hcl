include "monolith" {
  path   = find_in_parent_folders("monolith.hcl")
  expose = true
}

terraform {
  source = include.monolith.locals.ic_stack_source
}

inputs = {
  name        = "sops-${include.monolith.locals.vars.environment}"
  description = "Encryption key for sops"
}
