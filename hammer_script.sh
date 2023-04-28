#!/bin/bash

PROJECT_ID="test-functions-185602"
LABEL_KEY="purpose"
LABEL_VALUE="maintenance"
REGION="us-central1"
ZONE="us-central1-a"

# Labeling Compute Engine instances
echo "Processing Compute Engine instances..."
INSTANCE_IDS=$(gcloud compute instances list --project "$PROJECT_ID" --format="value(name)")
for INSTANCE_ID in $INSTANCE_IDS; do
  echo "Updating $INSTANCE_ID with label $LABEL_KEY:$LABEL_VALUE"
  gcloud compute instances update "$INSTANCE_ID" --project "$PROJECT_ID" --zone "$ZONE" --update-labels "$LABEL_KEY=$LABEL_VALUE" --quiet
done

# Labeling Kubernetes Engine clusters
echo "Processing Kubernetes Engine clusters..."
GKE_CLUSTER_IDS=$(gcloud container clusters list --project "$PROJECT_ID" --region "$REGION" --format="value(name)")
for GKE_CLUSTER_ID in $GKE_CLUSTER_IDS; do
  echo "Updating $GKE_CLUSTER_ID with label $LABEL_KEY:$LABEL_VALUE"
  gcloud container clusters update "$GKE_CLUSTER_ID" --project "$PROJECT_ID" --region "$REGION" --update-labels "$LABEL_KEY=$LABEL_VALUE" --quiet
done