### Github Self Hosted Runner With SSM
#### Gergo Nagy Practice Project for Code Factory

##### Description:
This project deploys a self-hosted GitHub Actions runner on an AWS EC2 instance within a private subnet
Terragrunt and Terraform Registry modules:
- tfr:///terraform-aws-modules/vpc/aws//.?version=5.14.0
- tfr:///terraform-aws-modules/ec2-instance/aws//.?version=5.8.0

The setup includes:
- VPC with private and public subnets
- NAT Gateway for internet access
- AWS Systems Manager (SSM) for secure instance access
- GitHub Actions workflow to list S3 buckets

The infrastructure is modularized for reusability and maintainability with Terragrunt and OpenTofu.

##### Runner:
- Current configuration: The Github Actions Self Hosted Runner is currently repo scoped to this repo. The List S3 Buckets workflow lists the S3 buckets of the AWS Account.

In the case of a different usage:
- github_token and github_repo keys in globals.hcl has to be modified.
- modules/iam module permissions has to be modified if necessary.

##### Prerequisites:
- AWS Account: Configured with sufficient permissions to create VPCs, EC2 instances, IAM roles, and SSM sessions.
- AWS CLI: Installed and configured with credentials (aws configure).
- Session Manager Plugin: Required for SSM access. Install it following AWS documentation.
- Terragrunt: Installed (version >= 0.38.0).
- OpenTofu: Version compatible with terraform-aws-modules/vpc/aws@v5.15.0 and terraform-aws-modules/ec2-instance/aws@v5.8.0.
- GitHub PAT: Personal Access Token with repo scope.
- GitHub Repository: A repository to register the runner and host the workflow.