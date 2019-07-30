#!/bin/bash
# Script to delete the workspace created by the loadAndRunWorkspace.sh script

# Make sure ATLAS_TOKEN environment variable is set
# to owners team token for organization

# Set address if using private Terraform Enterprise server.
# Set organization and workspace to create.
# You should edit these before running.
address="app.terraform.io"
organization="ppresto_ptfe"
workspace="auto-tfc-workspace-sandbox"
sleep_duration=5
# Set workspace if provided as the second argument
if [ ! -z $1 ]; then
  workspace=$1
  echo "Using workspace provided as argument: " $workspace
else
  echo "Using workspace set in the script."
fi

# Find the workspace
echo "Checking to see if workspace exists"
check_workspace_result=$(curl -s --header "Authorization: Bearer $ATLAS_TOKEN" --header "Content-Type: application/vnd.api+json" "https://${address}/api/v2/organizations/${organization}/workspaces/${workspace}")

if [[ $? != 0 ]]; then
  echo "Workspace not found"
  exit 1
fi

# Parse workspace_id from check_workspace_result
workspace_id=$(echo $check_workspace_result | python -c "import sys, json; print(json.load(sys.stdin)['data']['id'])")
echo "Workspace ID: " $workspace_id
sed "s/workspace_id/${workspace_id}/g" < run_destroy.template.json > run_destroy.json

# Run Destroy plan
run_destroy_plan=$(curl -s --header "Authorization: Bearer $ATLAS_TOKEN" --header "Content-Type: application/vnd.api+json" --data @run_destroy.json https://${address}/api/v2/runs)

# Parse run_result
run_id=$(echo $run_destroy_plan | python -c "import sys, json; print(json.load(sys.stdin)['data']['id'])")
echo "Run ID: " $run_id

continue=1
while [ $continue -ne 0 ]; do
  # Sleep
  sleep $sleep_duration
  #echo "Checking run status"

  # Check the status of run
  check_result=$(curl -s --header "Authorization: Bearer $ATLAS_TOKEN" --header "Content-Type: application/vnd.api+json" https://${address}/api/v2/runs/${run_id})

  # Parse out the run status and is-confirmable
  run_status=$(echo $check_result | python -c "import sys, json; print(json.load(sys.stdin)['data']['attributes']['status'])")
  #echo "Run Status: " $run_status
  is_confirmable=$(echo $check_result | python -c "import sys, json; print(json.load(sys.stdin)['data']['attributes']['actions']['is-confirmable'])")
  #echo "Run can be applied: " $is_confirmable
  echo "run status: ${run_status} , is_confirmable: ${is_confirmable} "
  if [[ "$is_confirmable" == "True" ]]; then
    run_apply=$(curl -s --header "Authorization: Bearer $ATLAS_TOKEN" --header "Content-Type: application/vnd.api+json" --request POST https://${address}/api/v2/runs/${run_id}/actions/apply)
    continue=0
  fi
done
