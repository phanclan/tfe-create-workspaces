# TFE Automation Script
Script to create or delete a workspace that is integrated to GitHub.  This was built to create your initial ADMIN Workspace which can used to create child workspaces that contain your sensitive credentials.

## Introduction
This script uses curl to interact with Terraform Enterprise via the Terraform Enterprise REST API. The same APIs could be used from Jenkins or other solutions to incorporate Terraform Enterprise into your CI/CD pipeline.

Three arguments can be provided on the command line when calling the script:
1. The first, **git_url**, is an optional URL for a git repository from which the script should clone some Terraform code.
1. The second, **workspace**, is the name of the workspace to use or create if it does not already exist. Note that TFE workspace names are not allowed to contain spaces. The script checks for this and will exit if workspace contains any spaces.


The script does the following steps:
1. Creates the workspace if it does not already exist.
1. Adds Terraform and environment variables using your current shell env.  It assumes you have your AWS, GCP, or Azure ENV variables available in your current shell.

Note that some json template files are included from which other json files are generated so that they can be passed to the curl commands.

## Setup
Do the following before using these scripts:

1. Make sure [python](https://www.python.org/downloads/) is installed on your machine and in your path since the script uses python to parse JSON documents returned by the Terraform Enterprise REST API.
1. If you are using a private Terraform Enterprise server, edit the script and set the address variable to the address of your server. Otherwise, you would leave the address set to "app.terraform.io" which is the address of the SaaS Terraform Enterprise server.
1. Edit the script and set the organization variable to the name of your Terraform Enterprise organization.
1. Generate a [team token](https://www.terraform.io/docs/enterprise/users-teams-organizations/service-accounts.html#team-service-accounts) for the owners team in your organization in the Terraform Enterprise UI by selecting your organization settings, then Teams, then owners, and then clicking the Generate button and saving the token that is displayed.
1. `export ATLAS_TOKEN=<owners_token>` where \<owners_token\> is the token generated in the previous step.
1. If you want, you can also change the name of the workspace that will be created by editing the workspace variable. Note that you can also pass the workspace as the second argument to the script.
1. If you want, you can change the sleep_duration variable which controls how often the script checks the status of the triggered run (in seconds). Setting a longer value would make sense if using Terraform code that takes longer to apply.
1. provide a URL to git repository as the first argument or update the default one in the script.

## Using with Private Terraform Enterprise Server using private CA
If you use this script with a Private Terraform Enterprise (PTFE) server that uses a private CA instead of a public CA, you will need to ensure that the curl commands run by the script will trust the private CA.  There are several ways to do this.  The first is easiest for enabling the automation script to run, but it only affects curl. The second and third are useful for using the Terraform and TFE CLIs against your PTFE server. The third is a permanent solution.
1. `export  CURL_CA_BUNDLE=<path_to_ca_bundle>`
1. Export the Golang SSL_CERT_FILE and/or SSL_CERT_DIR environment variables. For instance, you could set the first of these to the same CA bundle used in option 1.
1. Copy your certificate bundle to /etc/pki/ca-trust/source/anchors and then run `update-ca-trust extract`.

## Usage (addAdminWorkspace.sh)
./addAdminWorkspace.sh
./addAdminWorkspace.sh <gitURL> <workspace_name>

## Usage (deleteWorkspace.sh)
./deleteWorkspace.sh
./addAdminWorkspace.sh <workspace_name>
