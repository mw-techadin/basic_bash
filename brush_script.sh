#!/bin/bash

PROJECT_ID=""
LABEL_KEY="purpose"
LABEL_VALUE="see-me"
REGION="us-central1"
ZONE="us-central1-a"

function label_compute_resources() {
  local RESOURCE_TYPE="$1"
  local LIST_COMMAND=(gcloud compute "$RESOURCE_TYPE" list --project "$PROJECT_ID" --format="value(id)")
  local UPDATE_COMMAND=(gcloud compute "$RESOURCE_TYPE" update --project "$PROJECT_ID" --update-labels "$LABEL_KEY=$LABEL_VALUE" --quiet)

  if [ "$RESOURCE_TYPE" != "instance-templates" ]; then
    LIST_COMMAND+=("--filter=zone:($ZONE)")
    UPDATE_COMMAND+=("--zone=$ZONE")
  fi

  local RESOURCE_IDS=$("${LIST_COMMAND[@]}")

  for RESOURCE_ID in $RESOURCE_IDS; do
    local LABELS=$(gcloud compute "$RESOURCE_TYPE" describe "$RESOURCE_ID" --project "$PROJECT_ID" --format="value(labels)")
    if [[ ! $LABELS == *"$LABEL_KEY"* ]]; then
      echo "Updating $RESOURCE_ID with label $LABEL_KEY:$LABEL_VALUE"
      "${UPDATE_COMMAND[@]}" "$RESOURCE_ID"
    else
      echo "Label $LABEL_KEY already exists on $RESOURCE_ID"
    fi
  done
}

# Labeling Compute Engine resources
COMPUTE_RESOURCES=("disks" "instances" "instance-templates")
for RESOURCE_TYPE in "${COMPUTE_RESOURCES[@]}"; do
  echo "Processing Compute Engine $RESOURCE_TYPE..."
  label_compute_resources "$RESOURCE_TYPE"
done

# Labeling Cloud Storage buckets
echo "Processing buckets..."
BUCKET_NAMES=$(gsutil ls -p "$PROJECT_ID")
for BUCKET_NAME in $BUCKET_NAMES; do
  echo "Updating $BUCKET_NAME with label $LABEL_KEY:$LABEL_VALUE"
  gsutil label ch -l "$LABEL_KEY:$LABEL_VALUE" "$BUCKET_NAME"
done

# Labeling Kubernetes Engine clusters
echo "Processing Kubernetes Engine clusters..."
GKE_CLUSTER_IDS=$(gcloud container clusters list --project "$PROJECT_ID" --region "$REGION" --format="value(name)")
for GKE_CLUSTER_ID in $GKE_CLUSTER_IDS; do
  echo "Updating $GKE_CLUSTER_ID with label $LABEL_KEY:$LABEL_VALUE"
  gcloud container clusters update "$GKE_CLUSTER_ID" --project "$PROJECT_ID" --region "$REGION" --update-labels "$LABEL_KEY=$LABEL_VALUE" --quiet
done
