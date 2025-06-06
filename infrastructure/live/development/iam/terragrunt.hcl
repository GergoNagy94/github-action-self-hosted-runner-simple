terraform {
  source = "${get_terragrunt_dir()}/../../../../modules/iam"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "no_merge"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
          vpc_id = "mock-vpc-id"
      }
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id

  tags = include.env.locals.tags
}

skip = include.env.locals.skip_module.iam