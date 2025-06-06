locals {
  global_vars = read_terragrunt_config(find_in_parent_folders("globals.hcl"))

  project = local.global_vars.locals.project
  region  = local.global_vars.locals.region
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = "${local.project}-${local.region}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.region
    encrypt        = true
    dynamodb_table = "${local.project}-${local.region}-lock"

    s3_bucket_tags = {
      Name        = local.project
      Environment = "shared"
      ManagedBy   = "Terragrunt"
    }

    dynamodb_table_tags = {
      Name        = local.project
      Environment = "shared"
      ManagedBy   = "Terragrunt"
    }
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region    = "${local.region}"
}
EOF
}