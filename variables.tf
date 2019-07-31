variable "tfe_token" {}

variable "oauth_token_id" {}

variable "organization" {}

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
    "tf-aws-ecs-fargate_master",
    "tf-aws-ecs-fargate_dev",
    "tf-google-instance",
    "tf-azure-instance",
    "tf-aws-instance_prod",
    "tf-aws-instance_dev",
  ]
}

# Team Access
variable "team_ops" {
  type = "map"

  default = {
    myapp_master = "write"
  }
}

variable "team_dev" {
  type = "map"

  default = {
    myapp_dev    = "write"
    myapp_master = "read"
    myapp_qa     = "read"
  }
}

# Default branch will be master unless defined below
variable "workspace_branch" {
  type = "map"

  default = {
    myapp_qa               = "qa"
    myapp_dev              = "dev"
    tf-aws-ecs-fargate_dev = "dev"
    tf-aws-instance_dev    = "dev"
  }
}

variable "repo_org" {}

variable "gcp_region" {}

variable "gcp_zone" {}

variable "gcp_project" {}

variable "gcp_credentials" {}

variable "aws_secret_access_key" {}

variable "aws_access_key_id" {}

variable "arm_subscription_id" {}

variable "arm_client_secret" {}

variable "arm_tenant_id" {}

variable "arm_client_id" {}
