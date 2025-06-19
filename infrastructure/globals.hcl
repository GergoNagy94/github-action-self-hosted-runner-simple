locals {
  project = "gergo-runner-demio-1"
  region  = "eu-central-1"

  github_token = get_env("GITHUB_TOKEN", "")
  github_repo  = "https://github.com/GergoNagy94/github-action-self-hosted-runner-simple.git"
  github_owner = "GergoNagy94"

  organization_id      = "a-acbdef1234"
  organization_root_id = "a-ab12"

  management_account_id  = "012345678910"
  monitoring_account_id  = "012345678910"
  production_account_id  = "012345678910"
  development_account_id = "012345678910"

  management_account_email  = "management@example.com"
  monitoring_account_email  = "monitoring@example.com"
  production_account_email  = "production@example.com"
  development_account_email = "development@example.com"
}