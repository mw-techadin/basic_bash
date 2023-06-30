#!/bin/bash

# Set your project ID
PROJECT_ID=solo-test-236622

# Set label key and value
LABEL_KEY=team
LABEL_VALUE=fe-presale

# No need to authenticate with GCP when you are using Cloud Shell
# Cloud Shell is already authenticated with your account.

# Set your project
gcloud config set project $PROJECT_ID

# Get a list of all the asset types in the project
ASSET_TYPES=$(gcloud asset search-all-resources --project=$PROJECT_ID --format='csv[no-heading](assetType)' | sort | uniq)

# Loop through the asset types and update each asset's labels
for ASSET_TYPE in $ASSET_TYPES
do
  ASSET_URNS=$(gcloud asset search-all-resources --project=$PROJECT_ID --asset-types=$ASSET_TYPE --format='csv[no-heading](name)')
  for ASSET_URN in $ASSET_URNS
  do
    # Please note that "gcloud asset labels update" is a placeholder. There's currently no such command.
    # You will need to use service-specific commands to add labels to assets.
    echo "Add labels to $ASSET_URN"
  done
done
