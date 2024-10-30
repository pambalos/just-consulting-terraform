
locals {
  module_vars = try(yamldecode(file(find_in_parent_folders("${get_terragrunt_dir()}/module.yaml"))), {})
  region_vars = try(yamldecode(file(find_in_parent_folders("region.yaml"))), {})
  environment_vars = try(yamldecode(file(find_in_parent_folders("environment.yaml"))), {})
  global_vars = try(yamldecode(file(find_in_parent_folders("global.yaml"))), {})

  vars = merge(
    local.global_vars,
    local.environment_vars,
    local.region_vars,
    local.module_vars
  )

  # repo vars
  repo_vars = jsondecode(run_cmd("--terragrunt-global-cache", "--terragrunt-quiet", "get-env-vars"))
  iac_dir = local.repo_vars.iac_dir_from_root
  repo_root      = local.repo_vars.repo_root

  provider_folder = "providers"

  providers         = lookup(local.module_vars, "providers", [])
  enable_aws        = contains(local.providers, "aws")

  stack_module = lookup(local.vars, "module", basename(get_original_terragrunt_dir()))
  ic_stack_source = "../../../../infrastructure//${local.stack_module}"

  is_local = true

  iac_path      = "/${local.iac_dir}//${lookup(local.vars, "module", basename(get_original_terragrunt_dir()))}"
  source        = "${local.repo_root}${local.iac_path}"
}

################################################################
### The main IaC source
################################################################

terraform {
  source = local.source

  # Force Terraform to keep trying to acquire a lock for
  # up to 30 minutes if someone else already has the lock
  extra_arguments "retry_lock" {
    commands = get_terraform_commands_that_need_locking()
    arguments = [
      local.is_local ? "-lock=false" : "-lock-timeout=30m"
    ]
  }

  # Fail fast if inputs are missing rather than prompting for
  # interactive input
  extra_arguments "input_validation" {
    commands = get_terraform_commands_that_need_input()
    arguments = [
      "-input=false",
    ]
  }
}

generate "aws_provider" {
  path      = "aws.tf"
  if_exists = "overwrite_terragrunt"
  contents = templatefile("${local.provider_folder}/aws.tftpl", {
    aws_region     = local.enable_aws ? local.vars.aws_region : ""
    aws_account_id = local.enable_aws ? local.vars.aws_account_id : ""
    aws_profile    = local.enable_aws ? local.vars.aws_profile : ""
  })
}

generate "aws_secondary_provider" {
  path      = "aws_secondary.tf"
  if_exists = "overwrite_terragrunt"
  # Note: If the aws provider is enabled, always enable the secondary as it removes a footgun at no extra cost
  contents = local.enable_aws ? templatefile("${local.provider_folder}/aws_secondary.tftpl", {
    aws_region     = local.enable_aws ? local.vars.aws_secondary_region : ""
    aws_account_id = local.enable_aws ? local.vars.aws_secondary_account_id : ""
    aws_profile    = local.enable_aws ? local.vars.aws_secondary_profile : ""
  }) : ""
}

generate "aws_global_provider" {
  path      = "aws_global.tf"
  if_exists = "overwrite_terragrunt"
  # Note: If the aws provider is enabled, always enable the global as it removes a footgun at no extra cost
  contents = local.enable_aws ? templatefile("${local.provider_folder}/aws_global.tftpl", {
    aws_account_id = local.enable_aws ? local.vars.aws_account_id : ""
    aws_profile    = local.enable_aws ? local.vars.aws_profile : ""
  }) : ""
}

generate "neon_provider" {
  path      = "neon.tf"
  if_exists = "overwrite_terragrunt"
  contents  = contains(local.providers, "neon") ? file("${local.provider_folder}/neon.tf") : ""
}

generate "random_provider" {
  path      = "random.tf"
  if_exists = "overwrite_terragrunt"
  contents  = contains(local.providers, "random") ? file("${local.provider_folder}/random.tf") : ""
}