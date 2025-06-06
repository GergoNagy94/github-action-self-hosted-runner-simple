terraform {
  source = "tfr:///terraform-aws-modules/ec2-instance/aws//.?version=5.8.0"
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
    vpc_id          = "mock-vpc-id"
    private_subnets = ["mock-private-subnet-1", "mock-private-subnet-2"]
  }
}

dependency "iam" {
  config_path = "../iam"

  mock_outputs = {
    security_group_id     = "mock-sg-id"
    instance_profile_name = "mock-instance-profile"
  }
}

inputs = {
  name                                = include.env.locals.runner_name
  ami                                 = include.env.locals.runner_ami
  instance_type                       = include.env.locals.runner_type
  subnet_id                           = dependency.vpc.outputs.private_subnets[0]
  vpc_security_group_ids              = [dependency.iam.outputs.security_group_id]
  iam_instance_profile                = dependency.iam.outputs.instance_profile_name
  user_data                           = include.env.locals.user_data
  runner_spot_instance                = include.env.locals.runner_spot_instance
  create_spot_instance                = include.env.locals.create_spot_instance
  spot_price                          = include.env.locals.spot_price
  spot_type                           = include.env.locals.spot_type
  spot_wait_for_fulfillment           = include.env.locals.spot_wait_for_fulfillment
  spot_instance_interruption_behavior = include.env.locals.spot_instance_interruption_behavior

  tags = include.env.locals.tags
}

skip = include.env.locals.skip_module.ec2