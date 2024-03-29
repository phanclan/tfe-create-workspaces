variable "tfe_token" {}

variable "oauth_token_id" {}

variable "organization" {}

variable "slackurl" {
  default = "https://hooks.slack.com/services/xxxxxxx"
}
# Workspace names will be used for the repo name when setting up VCS.
# If you want a workspace to start with "ADMIN" this will be removed
# from the VCS repo name we attempt to connect to.
variable "workspace_ids" {
  type = "list"

  default = [
    "ADMIN-tfe-policies-example",
    "tf-aws-ecs-fargate",
    "tf-google-gce-instance",
    "tf-azurerm-az-instance",
    "tf-aws-ec2-instance",
    "tf-aws-standard-network",
    "patspets_dev",
  ]
}

variable "cicd_workspace_ids" {
  type = "list"

  default = ["patspets_stage", "patspets_master"]
}

#
### Workspace Customizations
#

# Repo working directory
variable "working_directory" {
  type = "map"
  default = {
    patspets_dev = "tfe/"
    tf-aws-ec2-instance = "examples/simple/"
  }
}

# Repo Branch if different from 'master'
variable "workspace_branch" {
  type = "map"

  default = {
    patspets_dev           = "dev"
  }
}

# Team "Operations" - Access
variable "ops_access" {
  type = "map"

  default = {
    repo   = "tf-aws-standard-network,patspets_stage,patspets_master"
    access = "write,read,write"
  }
}

resource "null_resource" "ops" {
  count = "${length(split(",", var.ops_access["repo"]))}"

  triggers {
    repo   = "${element(split(",", var.ops_access["repo"]), count.index)}"
    access = "${element(split(",", var.ops_access["access"]), count.index)}"
  }
}

# Team "Development" - Access
variable "dev_access" {
  type = "map"

  default = {
    repo   = "tf-aws-standard-network,patspets_dev,patspets_stage,patspets_master"
    access = "read,read,read,read"
  }
}

resource "null_resource" "dev" {
  count = "${length(split(",", var.dev_access["repo"]))}"

  triggers {
    repo   = "${element(split(",", var.dev_access["repo"]), count.index)}"
    access = "${element(split(",", var.dev_access["access"]), count.index)}"
  }
}

# Team "Network" - Access
variable "net_access" {
  type = "map"

  default = {
    repo   = "tf-aws-standard-network"
    access = "write"
  }
}

resource "null_resource" "net" {
  count = "${length(split(",", var.net_access["repo"]))}"

  triggers {
    repo   = "${element(split(",", var.net_access["repo"]), count.index)}"
    access = "${element(split(",", var.net_access["access"]), count.index)}"
  }
}

variable "repo_org" {}

variable "gcp_region" {}

variable "gcp_zone" {}

variable "gcp_project" {}

variable "gcp_credentials" {}

variable "aws_default_region" {}

variable "aws_secret_access_key" {}

variable "aws_access_key_id" {}

variable "arm_subscription_id" {}

variable "arm_client_secret" {}

variable "arm_tenant_id" {}

variable "arm_client_id" {}

