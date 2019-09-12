provider "tfe" {
  #version = "<= 0.7.0"
  token   = "${var.tfe_token}"
}
resource "tfe_workspace" "cicd-template" {
  count             = "${length(var.cicd_workspace_ids)}"
  name              = "${element(var.cicd_workspace_ids, count.index)}"
  organization      = "${var.organization}"
  terraform_version = "0.11.14"
  auto_apply        = true
}

resource "tfe_workspace" "template" {
  count             = "${length(var.workspace_ids)}"
  name              = "${element(var.workspace_ids, count.index)}"
  organization      = "${var.organization}"
  terraform_version = "0.11.14"
  queue_all_runs    = false
  auto_apply        = true
  working_directory = "${lookup(var.working_directory),element(var.workspace_ids, count.index),"."}"

  vcs_repo {
    identifier     = "${var.repo_org}/${replace(element(var.workspace_ids, count.index), "/^(ADMIN-)?([0-9A-Za-z-]+)(_.*)?$/", "$2")}"
    oauth_token_id = "${var.oauth_token_id}"
    branch         = "${lookup(var.workspace_branch, element(var.workspace_ids, count.index), "master")}"
  }
}

resource "tfe_team" "ops" {
  name         = "Operations"
  organization = "${var.organization}"
}
resource "tfe_team" "dev" {
  name         = "Development"
  organization = "${var.organization}"
}
resource "tfe_team" "net" {
  name         = "Network"
  organization = "${var.organization}"
}
resource "tfe_team" "sec" {
  name         = "Security"
  organization = "${var.organization}"
}

resource "tfe_team_member" "ops" {
  team_id  = "${tfe_team.ops.id}"
  username = "ppresto-ops"
}

resource "tfe_team_member" "net" {
  team_id  = "${tfe_team.net.id}"
  username = "ppresto-ops"
}

resource "tfe_team_member" "dev" {
  team_id  = "${tfe_team.dev.id}"
  username = "ppresto-dev"
}

resource "tfe_team_access" "ops" {
  count = "${length(split(",", var.ops_access["repo"]))}"
  #access       = "${element(split(",", var.ops_access["priv"]), count.index)}"
  access       = "${element(null_resource.ops.*.triggers.access, count.index)}"
  team_id      = "${tfe_team.ops.id}"
  workspace_id = "${var.organization}/${element(null_resource.ops.*.triggers.repo, count.index)}"
}

resource "tfe_team_access" "dev" {
  count = "${length(split(",", var.dev_access["repo"]))}"
  #access       = "${element(split(",", var.ops_access["priv"]), count.index)}"
  access       = "${element(null_resource.dev.*.triggers.access, count.index)}"
  team_id      = "${tfe_team.dev.id}"
  workspace_id = "${var.organization}/${element(null_resource.dev.*.triggers.repo, count.index)}"
}

resource "tfe_team_access" "net" {
  count = "${length(split(",", var.net_access["repo"]))}"
  #access       = "${element(split(",", var.net_access["priv"]), count.index)}"
  access       = "${element(null_resource.net.*.triggers.access, count.index)}"
  team_id      = "${tfe_team.net.id}"
  workspace_id = "${var.organization}/${element(null_resource.net.*.triggers.repo, count.index)}"
}

resource "tfe_variable" "gcp_project" {
  count        = "${length(concat(var.workspace_ids,var.cicd_workspace_ids))}"
  key          = "GOOGLE_PROJECT"
  value        = "${var.gcp_project}"
  category     = "env"
  sensitive    = false
  workspace_id = "${var.organization}/${element(concat(var.workspace_ids,var.cicd_workspace_ids), count.index)}"
  depends_on   = ["tfe_workspace.template","tfe_workspace.cicd-template"]
}

resource "tfe_variable" "gcp_credentials" {
  count        = "${length(concat(var.workspace_ids,var.cicd_workspace_ids))}"
  key          = "GOOGLE_CREDENTIALS"
  value        = "${var.gcp_credentials}"
  category     = "env"
  sensitive    = true
  workspace_id = "${var.organization}/${element(concat(var.workspace_ids,var.cicd_workspace_ids), count.index)}"
  depends_on   = ["tfe_workspace.template","tfe_workspace.cicd-template"]
}

resource "tfe_variable" "aws_secret_access_key" {
 count        = "${length(concat(var.workspace_ids,var.cicd_workspace_ids))}"
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = "${var.aws_secret_access_key}"
  category     = "env"
  sensitive    = true
  workspace_id = "${var.organization}/${element(concat(var.workspace_ids,var.cicd_workspace_ids), count.index)}"
  depends_on   = ["tfe_workspace.template","tfe_workspace.cicd-template"]
}

resource "tfe_variable" "aws_access_key_id" {
  count        = "${length(concat(var.workspace_ids,var.cicd_workspace_ids))}"
  key          = "AWS_ACCESS_KEY_ID"
  value        = "${var.aws_access_key_id}"
  category     = "env"
  sensitive    = true
  workspace_id = "${var.organization}/${element(concat(var.workspace_ids,var.cicd_workspace_ids), count.index)}"
  depends_on   = ["tfe_workspace.template","tfe_workspace.cicd-template"]
}

resource "tfe_variable" "aws_default_region" {
  count        = "${length(concat(var.workspace_ids,var.cicd_workspace_ids))}"
  key          = "AWS_DEFAULT_REGION"
  value        = "${var.aws_default_region}"
  category     = "env"
  sensitive    = false
  workspace_id = "${var.organization}/${element(concat(var.workspace_ids,var.cicd_workspace_ids), count.index)}"
  depends_on   = ["tfe_workspace.template","tfe_workspace.cicd-template"]
}

resource "tfe_variable" "arm_subscription_id" {
 count        = "${length(concat(var.workspace_ids,var.cicd_workspace_ids))}"
  key          = "ARM_SUBSCRIPTION_ID"
  value        = "${var.arm_subscription_id}"
  category     = "env"
  sensitive    = true
  workspace_id = "${var.organization}/${element(concat(var.workspace_ids,var.cicd_workspace_ids), count.index)}"
  depends_on   = ["tfe_workspace.template","tfe_workspace.cicd-template"]
}

resource "tfe_variable" "arm_client_secret" {
 count        = "${length(concat(var.workspace_ids,var.cicd_workspace_ids))}"
  key          = "ARM_CLIENT_SECRET"
  value        = "${var.arm_client_secret}"
  category     = "env"
  sensitive    = true
  workspace_id = "${var.organization}/${element(concat(var.workspace_ids,var.cicd_workspace_ids), count.index)}"
  depends_on   = ["tfe_workspace.template","tfe_workspace.cicd-template"]
}

resource "tfe_variable" "arm_tenant_id" {
  count        = "${length(concat(var.workspace_ids,var.cicd_workspace_ids))}"
  key          = "ARM_TENANT_ID"
  value        = "${var.arm_tenant_id}"
  category     = "env"
  sensitive    = true
  workspace_id = "${var.organization}/${element(concat(var.workspace_ids,var.cicd_workspace_ids), count.index)}"
  depends_on   = ["tfe_workspace.template","tfe_workspace.cicd-template"]
}

resource "tfe_variable" "arm_client_id" {
  count        = "${length(concat(var.workspace_ids,var.cicd_workspace_ids))}"
  key          = "ARM_CLIENT_ID"
  value        = "${var.arm_client_id}"
  category     = "env"
  sensitive    = true
  workspace_id = "${var.organization}/${element(concat(var.workspace_ids,var.cicd_workspace_ids), count.index)}"
  depends_on   = ["tfe_workspace.template","tfe_workspace.cicd-template"]
}

resource "tfe_variable" "env_vars" {
  count        = "${length(concat(var.workspace_ids,var.cicd_workspace_ids))}"
  key          = "CONFIRM_DESTROY"
  value        = "1"
  category     = "env"
  workspace_id = "${var.organization}/${element(concat(var.workspace_ids,var.cicd_workspace_ids), count.index)}"
  depends_on   = ["tfe_workspace.template","tfe_workspace.cicd-template"]
}

resource "tfe_variable" "gcp_region" {
  count        = "${length(concat(var.workspace_ids,var.cicd_workspace_ids))}"
  key          = "GOOGLE_REGION"
  value        = "${var.gcp_region}"
  category     = "env"
  sensitive    = false
  workspace_id = "${var.organization}/${element(concat(var.workspace_ids,var.cicd_workspace_ids), count.index)}"
  depends_on   = ["tfe_workspace.template","tfe_workspace.cicd-template"]
}

resource "tfe_variable" "gcp_zone" {
  count        = "${length(concat(var.workspace_ids,var.cicd_workspace_ids))}"
  key          = "GOOGLE_ZONE"
  value        = "${var.gcp_zone}"
  category     = "env"
  sensitive    = false
  workspace_id = "${var.organization}/${element(concat(var.workspace_ids,var.cicd_workspace_ids), count.index)}"
  depends_on   = ["tfe_workspace.template","tfe_workspace.cicd-template"]
}

resource "tfe_variable" "name_prefix" {
  count        = "${length(concat(var.workspace_ids,var.cicd_workspace_ids))}"
  key          = "name_prefix"
  value        = "${element(concat(var.workspace_ids,var.cicd_workspace_ids), count.index)}-presto"
  category     = "terraform"
  sensitive    = false
  workspace_id = "${var.organization}/${element(concat(var.workspace_ids,var.cicd_workspace_ids), count.index)}"
  depends_on   = ["tfe_workspace.template","tfe_workspace.cicd-template"]
}

# Special Workspace Configuration Requirements here...
resource "tfe_variable" "tfe_token" {
  #count        = "${length(var.workspace_ids)}"
  key          = "tfe_token"
  value        = "${var.tfe_token}"
  category     = "terraform"
  sensitive    = true
  workspace_id = "${var.organization}/ADMIN-tfe-policies-example"
  depends_on   = ["tfe_workspace.template","tfe_workspace.cicd-template"]
}

