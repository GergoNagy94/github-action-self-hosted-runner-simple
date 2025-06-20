locals {
  global_vars = read_terragrunt_config(find_in_parent_folders("globals.hcl"))

  project    = local.global_vars.locals.project
  account_id = local.global_vars.locals.development_account_id
  env        = "development"

  github_token  = local.global_vars.locals.github_token
  github_repo   = local.global_vars.locals.github_repo
  github_owner  = local.global_vars.locals.github_owner
  runner_labels = local.global_vars.locals.runner_labels

  skip_module = {
    iam = false
    ec2 = false
    vpc = false
  }

  #VPC
  vpc_cidr                   = "10.0.0.0/16"
  vpc_nat_gateway            = true
  vpc_single_nat_gateway     = true
  vpc_create_egress_only_igw = true
  vpc_enable_dns_hostnames   = true
  vpc_enable_dns_support     = true
  region                     = "eu-central-1"
  availability_zone          = ["eu-central-1a", "eu-central-1b"]

  # GitHub Runner
  runner_name = "test-runner-${local.env}-${local.project}"
  runner_ami  = "ami-092ff8e60e2d51e19"
  runner_type = "t3.medium"
  user_data = templatefile(find_in_parent_folders("scripts/user_data.sh"), {
    github_token  = local.github_token
    github_repo   = local.github_repo
    github_owner  = local.github_owner
    runner_name   = local.runner_name
    runner_labels = local.runner_labels
  })
  create_spot_instance                = true
  spot_price                          = "0.08"
  spot_type                           = "persistent"
  spot_wait_for_fulfillment           = true
  spot_instance_interruption_behavior = "terminate"

  # Tags
  tags = {
    Name        = "${local.env}-${local.project}"
    Environment = "${local.env}"
    Project     = "${local.project}"
    ManagedBy   = "Terragrunt"
  }
}