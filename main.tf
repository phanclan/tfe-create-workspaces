provider "tfe" {
  version = "<= 0.7.0"
  token   = "${var.tfe_token}"
}

resource "tfe_workspace" "template" {
  count             = "${length(var.workspace_ids)}"
  name              = "${element(var.workspace_ids, count.index)}"
  organization      = "${var.organization}"
  terraform_version = "0.11.14"
  queue_all_runs    = false
  auto_apply        = true

  vcs_repo {
    identifier     = "${var.repo_org}/${replace(element(var.workspace_ids, count.index), "/^(ADMIN-)?([0-9A-Za-z-]+)(_.*)?$/", "$2")}"
    oauth_token_id = "${var.oauth_token_id}"
    branch         = "${lookup(var.workspace_branch, element(var.workspace_ids, count.index), "master")}"
  }
}

resource "tfe_team" "teams" {
  count        = "${length(var.teams)}"
  name         = "${element(var.teams, count.index)}"
  organization = "${var.organization}"
}

resource "tfe_team_access" "test" {
  access       = "read"
  team_id      = "${element(tfe_team.teams.id, count.index)}"
  workspace_id = "${var.organization}/${element(var.workspace_ids, count.index)}"
}

resource "tfe_variable" "gcp_project" {
  count        = "${length(var.workspace_ids)}"
  key          = "GOOGLE_PROJECT"
  value        = "${var.gcp_project}"
  category     = "env"
  sensitive    = false
  workspace_id = "${var.organization}/${element(var.workspace_ids, count.index)}"
  depends_on   = ["tfe_workspace.template"]
}

resource "tfe_variable" "gcp_credentials" {
  count        = "${length(var.workspace_ids)}"
  key          = "GOOGLE_CREDENTIALS"
  value        = "${var.gcp_credentials}"
  category     = "env"
  sensitive    = true
  workspace_id = "${var.organization}/${element(var.workspace_ids, count.index)}"
  depends_on   = ["tfe_workspace.template"]
}

resource "tfe_variable" "aws_secret_access_key" {
  count        = "${length(var.workspace_ids)}"
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = "${var.aws_secret_access_key}"
  category     = "env"
  sensitive    = true
  workspace_id = "${var.organization}/${element(var.workspace_ids, count.index)}"
  depends_on   = ["tfe_workspace.template"]
}

resource "tfe_variable" "aws_access_key_id" {
  count        = "${length(var.workspace_ids)}"
  key          = "AWS_ACCESS_KEY_ID"
  value        = "${var.aws_access_key_id}"
  category     = "env"
  sensitive    = true
  workspace_id = "${var.organization}/${element(var.workspace_ids, count.index)}"
  depends_on   = ["tfe_workspace.template"]
}

resource "tfe_variable" "arm_subscription_id" {
  count        = "${length(var.workspace_ids)}"
  key          = "ARM_SUBSCRIPTION_ID"
  value        = "${var.arm_subscription_id}"
  category     = "env"
  sensitive    = true
  workspace_id = "${var.organization}/${element(var.workspace_ids, count.index)}"
  depends_on   = ["tfe_workspace.template"]
}

resource "tfe_variable" "arm_client_secret" {
  count        = "${length(var.workspace_ids)}"
  key          = "ARM_CLIENT_SECRET"
  value        = "${var.arm_client_secret}"
  category     = "env"
  sensitive    = true
  workspace_id = "${var.organization}/${element(var.workspace_ids, count.index)}"
  depends_on   = ["tfe_workspace.template"]
}

resource "tfe_variable" "arm_tenant_id" {
  count        = "${length(var.workspace_ids)}"
  key          = "ARM_TENANT_ID"
  value        = "${var.arm_tenant_id}"
  category     = "env"
  sensitive    = true
  workspace_id = "${var.organization}/${element(var.workspace_ids, count.index)}"
  depends_on   = ["tfe_workspace.template"]
}

resource "tfe_variable" "arm_client_id" {
  count        = "${length(var.workspace_ids)}"
  key          = "ARM_CLIENT_ID"
  value        = "${var.arm_client_id}"
  category     = "env"
  sensitive    = true
  workspace_id = "${var.organization}/${element(var.workspace_ids, count.index)}"
  depends_on   = ["tfe_workspace.template"]
}

resource "tfe_variable" "env_vars" {
  count        = "${length(var.workspace_ids)}"
  key          = "CONFIRM_DESTROY"
  value        = "1"
  category     = "env"
  workspace_id = "${var.organization}/${element(var.workspace_ids, count.index)}"
  depends_on   = ["tfe_workspace.template"]
}

resource "tfe_variable" "gcp_region" {
  count        = "${length(var.workspace_ids)}"
  key          = "GOOGLE_REGION"
  value        = "${var.gcp_region}"
  category     = "env"
  sensitive    = false
  workspace_id = "${var.organization}/${element(var.workspace_ids, count.index)}"
  depends_on   = ["tfe_workspace.template"]
}

resource "tfe_variable" "gcp_zone" {
  count        = "${length(var.workspace_ids)}"
  key          = "GOOGLE_ZONE"
  value        = "${var.gcp_zone}"
  category     = "env"
  sensitive    = false
  workspace_id = "${var.organization}/${element(var.workspace_ids, count.index)}"
  depends_on   = ["tfe_workspace.template"]
}

resource "tfe_variable" "tfe_token" {
  count        = "${length(var.workspace_ids)}"
  key          = "tfe_token"
  value        = "${var.tfe_token}"
  category     = "terraform"
  sensitive    = true
  workspace_id = "${var.organization}/${element(var.workspace_ids, count.index)}"
  depends_on   = ["tfe_workspace.template"]
}

resource "tfe_variable" "name_prefix" {
  count        = "${length(var.workspace_ids)}"
  key          = "name_prefix"
  value        = "${element(var.workspace_ids, count.index)}"
  category     = "terraform"
  sensitive    = false
  workspace_id = "${var.organization}/${element(var.workspace_ids, count.index)}"
  depends_on   = ["tfe_workspace.template"]
}
