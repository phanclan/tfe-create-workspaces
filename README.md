# tfe-create-workspaces
Create/Manage your Terraform Enterprise Organizations Workspaces using an existing "Admin" Workspace as a template.

## Create your initial Admin Workspace (TFE API)
Create your initial Admin workspace using the TFE API.  Please review the bash script and udpate as needed for your env.

```
cd scripts 
./addAdminWorkspace.sh
```
The addAdminWorkspace.sh that will create your initial TF Admin Workspace with the variables you may need to support TFE/TFC, AWS, Azure.  Update the variables and your environment to ensure you have the proper env variables accessible to this script so it properly builds out your Admin workspace.


Note: GCP is partially covered but you will have to cut/paste the GOOGLE_CREDENTIALS to the variable due to my shell script limitations.

## Create your Sub-Workspaces (TFE Provider)
Create one to many EFT workspaces based on your Admin workspace above.  Update the variables.tf with your workspaces and teams first.  Then 

```
cd ..
terraform init
terraform plan
terraform apply
```

## Optional - CICD-Workspace (TFE CLI)

Create an EFT Token with plan/apply permissions and set this to APP_TFE_TOKEN.  This script will setup your .terraformrc with your APP_TFE_TOKEN which will allow you to connect to TFE/TFC and create your cicd workspace.  It will  source your env and setup your sensitive credentials to be added to your cicd workspace.  Once its complete it will remove all sensitive information excluding your shell env.

Note: setup the same env requirements needed to create your initial Admin workspace above.  These will be used to populate your CICD workspace variables.  

```
cd cicd
./create.sh
```
