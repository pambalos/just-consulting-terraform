include monolith {
    path   = find_in_parent_folders("monolith.hcl")
    expose = true
}

terraform {
    source = include.monolith.locals.ic_stack_source
}

inputs = {
  db_name = "neon-terraform-db"
  db_region = "us-east-1"
  neon_project_name = "neon-terraform-project"
  neon_role_name = "neon-terraform-role"
}

#skip = true