terraform {
  required_providers {}
}

locals {
  sanitized_tags = {
    for k, v in var.extra_tags : replace(k, "/[^\\p{L}\\p{Z}\\p{N}_.:/=+\\-@]/", ".") => replace(v, "/[^\\p{L}\\p{Z}\\p{N}_.:/=+\\-@]/", ".")
  }

  aws_tags = merge(local.sanitized_tags, {
    "monolith/environment"   = var.environment
    "monolith/region"        = var.region
    "monolith/root-module"   = var.root_module
    "monolith/module"        = var.module
    "monolith/local"         = var.is_local ? "true" : "false",
  })
}
