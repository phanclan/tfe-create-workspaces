variable "slackurl" {
  default = "https://hooks.slack.com/services/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"
}

variable "cicd_workspace_ids" {
  default = "cicd-patspets"
}

# Default branch will be master unless defined below
variable "workspace_branch" {
  type = "map"

  default = {
    cicd-patspets = "master",
  }
}