terraform {
  required_providers {
    neon = {
      source = "terraform-community-providers/neon"
      version = "0.1.8"
    }
  }
}

resource "neon_database" "core_db" {
  name = var.db_name
  owner_name = neon_role.neon_role.name
  branch_id  = neon_project.main.branch.id
  project_id = neon_project.main.id
}

#resource "neon_branch" "main" {
#  name       = "main"
#  parent_id  = neon_project.neon_project.branch.id
#  project_id = neon_project.neon_project.id
#}

resource "neon_project" "main" {
  name      = var.neon_project_name
  region_id = "aws-${var.db_region}"
}

resource "neon_role" "neon_role" {
  name       = var.neon_role_name
  branch_id  = neon_project.main.branch.id
  project_id = neon_project.main.id
}
