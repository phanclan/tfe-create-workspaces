variable "tfe_token" {}

variable "oauth_token_id" {}

variable "organization" {}

variable "slackurl" {
  default = "https://hooks.slack.com/services/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"
}
# Workspace names will be used for the repo name when setting up VCS.
# If you want a workspace to start with "ADMIN" this will be removed
# from the VCS repo name we attempt to connect to.
variable "workspace_ids" {
  type = "list"

  default = [
    "ADMIN-tfe-policies-example",
    "myapp_master",
    "myapp_dev",
    "myapp_qa",
    "tf-aws-ecs-fargate",
    "tf-google-gce-instance",
    "tf-azurerm-az-instance",
    "tf-aws-ec2-instance",
    "tf-aws-standard-network",
    "patspets_stage",
  ]
}

variable "patspets_stage" {
  type = "map"
  default = {
    working_directory = "tfe/"
  }
}

variable "cicd_workspace_ids" {
  type = "list"

  default = ["patspets_master"]
}

# Team "Operations" - Access
variable "ops_access" {
  type = "map"

  default = {
    repo   = "myapp_master,myapp_dev,myapp_qa,tf-aws-standard-network"
    access = "write,read,read,read"
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
    repo   = "myapp_master,myapp_dev,myapp_qa,tf-aws-standard-network"
    access = "read,write,write,read"
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
    repo   = "myapp_master,myapp_dev,myapp_qa,tf-aws-standard-network"
    access = "read,read,read,write"
  }
}

resource "null_resource" "net" {
  count = "${length(split(",", var.net_access["repo"]))}"

  triggers {
    repo   = "${element(split(",", var.net_access["repo"]), count.index)}"
    access = "${element(split(",", var.net_access["access"]), count.index)}"
  }
}

# Default branch will be master unless defined below
variable "workspace_branch" {
  type = "map"

  default = {
    myapp_qa               = "qa"
    myapp_dev              = "dev"
    patspets_stage          = "stage"
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

