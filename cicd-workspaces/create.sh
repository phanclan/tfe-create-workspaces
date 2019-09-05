#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export TERRAFORM_CONFIG="${DIR}/.terraformrc"

# This is for the time to wait when using demo_magic.sh
if [[ -z ${DEMO_WAIT} ]];then
  DEMO_WAIT=0
fi

# Demo magic gives wrappers for running commands in demo mode.   Also good for learning via CLI.
. ${DIR}/../demo-magic.sh -d -p -w ${DEMO_WAIT}

source $HOME/awsSetEnv.sh
source $HOME/gcpSetEnv.sh
source $HOME/azSetEnv.sh

if [[ -z ${APP_TFE_TOKEN} ]]; then
  echo "Missing Required Env Variable: APP_TFE_TOKEN"
  echo "please set APP_TFE_TOKEN so this script can create the necessary .terraformrc"
  echo "export APP_TFE_TOKEN=<Terraform Enterprise App Token>"
  exit 1
fi

cyan "Create .terraformrc file with your TFE credentials"
p "cat <<- CONFIG > ./.terraformrc
credentials \"app.terraform.io\" {
  token = "xxxxxxx"
}
CONFIG"

# Create .terraformrc to enable TFE backend
cat <<- CONFIG > ${DIR}/.terraformrc
credentials "app.terraform.io" {
  token = "${APP_TFE_TOKEN}"
}
CONFIG

# Create a temporary variables file with sensitive credentials used for this run.
cat <<- VARS > ${DIR}/variables.tfvars.tf
variable "tfe_token" {   default = "${APP_TFE_TOKEN}" }

variable "organization" {   default = "Patrick" }

variable "repo_org" {   default = "ppresto" }

variable "gcp_region" {   default = "us-west1" }

variable "gcp_zone" {   default = "us-west1-b" }

variable "gcp_project" {   default = "ppresto-gcp-245517" }

variable "gcp_credentials" {   default = "" }

variable "aws_secret_access_key" {   default = "${AWS_SECRET_ACCESS_KEY}" }

variable "aws_access_key_id" {   default = "${AWS_ACCESS_KEY}" }

variable "arm_subscription_id" {   default = "${ARM_SUBSCRIPTION_ID}" }

variable "arm_client_secret" {   default = "${ARM_CLIENT_SECRET}" }

variable "arm_tenant_id" {   default = "${ARM_TENANT_ID}" }

variable "arm_client_id" {   default = "${ARM_CLIENT_ID}" }
VARS

cyan "Run Terraform init"
pe "terraform init"

cyan "Run Terraform apply"
pe "terraform apply -auto-approve"

# clean up sensitive files
rm ${DIR}/variables.tfvars.tf
rm ${DIR}/.terraformrc