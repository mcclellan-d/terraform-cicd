# --- root/main.tf ---

locals {
  aws_creds = {
    AWS_ACCESS_KEY_ID     = var.AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY = var.AWS_SECRET_ACCESS_KEY
  }
  organization = "isekai"
}

resource "github_repository" "mtc_repo" {
  name             = "mtc-dev-repo"
  description      = "VPC and Compute Resources"
  auto_init        = true
  license_template = "mit"

  visibility = "private"
}

resource "github_branch_default" "default" {
  repository = github_repository.mtc_repo.name
  branch     = "main"
}

resource "github_repository_file" "maintf" {
  repository          = github_repository.mtc_repo.name
  branch              = "main"
  file                = "main.tf"
  content             = file("./deployments/mtc-dev/main.tf")
  commit_author       = "mcclellan-d"
  commit_email        = "119080783+mcclellan-d@users.noreply.github.com"
  overwrite_on_create = true
}


resource "tfe_oauth_client" "mtc_oauth" {
  organization = local.organization
  api_url      = "https://api.github.com"
  http_url     = "https://github.com"
  oauth_token  = var.github_token
  service_provider = "github"
}

resource "tfe_workspace" "mtc_workspace" {
  name         = github_repository.mtc_repo.name
  organization = local.organization
  vcs_repo {
    identifier     = "${var.github_owner}/${github_repository.mtc_repo.name}"
    oauth_token_id = tfe_oauth_client.mtc_oauth.oauth_token_id
  }
}

resource "tfe_variable" "aws_creds" {
  for_each      = local.aws_creds
  key          = each.key
  value        = each.value
  category     = "env"
  sensitive    = true
  workspace_id = tfe_workspace.mtc_workspace.id
  description  = "AWS Creds"
}