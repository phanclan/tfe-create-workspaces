provider "tfe" {
  #version = "<= 0.7.0"
  token   = "${var.tfe_token}"
}

data "tfe_workspace_ids" "cicd" {
  names        = ["${var.cicd_workspace_ids}"]
  organization = "${var.organization}"
}

resource "tfe_variable" "gcp_project" {
  key          = "GOOGLE_PROJECT"
  value        = "${var.gcp_project}"
  category     = "env"
  sensitive    = false
  workspace_id = "${data.tfe_workspace_ids.cicd.ids[var.cicd_workspace_ids]}"
}

resource "tfe_variable" "gcp_credentials" {
  
  key          = "GOOGLE_CREDENTIALS"
  value        = "${var.gcp_credentials}"
  category     = "env"
  sensitive    = true
  workspace_id = "${data.tfe_workspace_ids.cicd.ids[var.cicd_workspace_ids]}"

}

resource "tfe_variable" "aws_secret_access_key" {
 
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = "${var.aws_secret_access_key}"
  category     = "env"
  sensitive    = true
  workspace_id = "${data.tfe_workspace_ids.cicd.ids[var.cicd_workspace_ids]}"

}

resource "tfe_variable" "aws_access_key_id" {
  
  key          = "AWS_ACCESS_KEY_ID"
  value        = "${var.aws_access_key_id}"
  category     = "env"
  sensitive    = true
  workspace_id = "${data.tfe_workspace_ids.cicd.ids[var.cicd_workspace_ids]}"

}

resource "tfe_variable" "arm_subscription_id" {
 
  key          = "ARM_SUBSCRIPTION_ID"
  value        = "${var.arm_subscription_id}"
  category     = "env"
  sensitive    = true
  workspace_id = "${data.tfe_workspace_ids.cicd.ids[var.cicd_workspace_ids]}"

}

resource "tfe_variable" "arm_client_secret" {
 
  key          = "ARM_CLIENT_SECRET"
  value        = "${var.arm_client_secret}"
  category     = "env"
  sensitive    = true
  workspace_id = "${data.tfe_workspace_ids.cicd.ids[var.cicd_workspace_ids]}"

}

resource "tfe_variable" "arm_tenant_id" {
  
  key          = "ARM_TENANT_ID"
  value        = "${var.arm_tenant_id}"
  category     = "env"
  sensitive    = true
  workspace_id = "${data.tfe_workspace_ids.cicd.ids[var.cicd_workspace_ids]}"

}

resource "tfe_variable" "arm_client_id" {
  
  key          = "ARM_CLIENT_ID"
  value        = "${var.arm_client_id}"
  category     = "env"
  sensitive    = true
  workspace_id = "${data.tfe_workspace_ids.cicd.ids[var.cicd_workspace_ids]}"

}

resource "tfe_variable" "env_vars" {
  
  key          = "CONFIRM_DESTROY"
  value        = "1"
  category     = "env"
  workspace_id = "${data.tfe_workspace_ids.cicd.ids[var.cicd_workspace_ids]}"

}

resource "tfe_variable" "gcp_region" {
  
  key          = "GOOGLE_REGION"
  value        = "${var.gcp_region}"
  category     = "env"
  sensitive    = false
  workspace_id = "${data.tfe_workspace_ids.cicd.ids[var.cicd_workspace_ids]}"

}

resource "tfe_variable" "gcp_zone" {
  
  key          = "GOOGLE_ZONE"
  value        = "${var.gcp_zone}"
  category     = "env"
  sensitive    = false
  workspace_id = "${data.tfe_workspace_ids.cicd.ids[var.cicd_workspace_ids]}"

}

# ERROR: Resource Not Found
#resource "tfe_notification_configuration" "test" {
#  
#  name                      = "Sentinel-Policy-Violation"
#  enabled                   = true
#  destination_type          = "slack"
#  triggers                  = ["run:needs_attention", "run:errored"]
#  url                       = "${var.slackurl}"
#  workspace_external_id     = "${tfe_workspace.template.*.external_id[count.index]}"
#
#}
