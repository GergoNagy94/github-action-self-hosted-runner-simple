locals {
  project = "gergo-runner-demio-1"
  region  = "eu-central-1"

  github_token = get_env("GITHUB_PAT", "")
  github_repo  = "github-action-self-hosted-runner-simple"
  github_owner = "GergoNagy94"
  runner_name = "gergo-runner-demio-1"

  development_account_id = "012345678910"
  development_account_email = "development@example.com"
}