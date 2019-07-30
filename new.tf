provider "tfe" {
  version = "<= 0.10.1"
  token   = "${var.tfe_token}"
}

resource "tfe_team" "dev" {
  name         = "Development"
  organization = "${var.organization}"
}

resource "tfe_team" "ops" {
  name         = "Operations"
  organization = "${var.organization}"
}

resource "tfe_team_access" "dev" {
  access       = "read"
  team_id      = "${tfe_team.dev.id}"
  workspace_id = "${var.organization}/${var.workspace_ids}"
}

resource "tfe_workspace" "template" {
  iterator = workspace
  foreach = var.workspace_ids
  content {
    name = workspace.value
  }
  organization      = "${var.organization}"
  terraform_version = "0.11.14"

  vcs_repo {
    identifier     = "${var.repo_org}/${replace(workspace), "/^(ADMIN-)?([0-9A-Za-z-]+)(_.*)?$/", "$2")}"
    oauth_token_id = "${var.oauth_token_id}"
    branch         = "${lookup(var.workspace_branch, workspace, "master")}"
  }
}

resource "tfe_variable" "gcp_project" {
  count        = "${length(var.workspace_ids)}"
  key          = "GOOGLE_PROJECT"
  value        = "${var.gcp_project}"
  category     = "env"
  sensitive    = false
  workspace_id = "${var.organization}/workspace"
  depends_on   = ["tfe_workspace.template"]
}
