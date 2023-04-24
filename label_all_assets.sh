#!/bin/bash

PROJECT_ID="test-functions-185602"
LABEL_KEY="team"
LABEL_VALUE="operations"
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
    echo "Updating $RESOURCE_ID with label $LABEL_KEY:$LABEL_VALUE"
    "${UPDATE_COMMAND[@]}" "$RESOURCE_ID"
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

# Labeling VPC networks
echo "Processing VPC networks..."
VPC_IDS=$(gcloud compute networks list --project "$PROJECT_ID" --format="value(name)")
for VPC_ID in $VPC_IDS; do
  echo "Updating $VPC_ID with label $LABEL_KEY:$LABEL_VALUE"
  gcloud compute networks update "$VPC_ID" --project "$PROJECT_ID" --update-labels "$LABEL_KEY=$LABEL_VALUE"
done

# Labeling subnetworks
echo "Processing subnetworks..."
SUBNET_IDS=$(gcloud compute networks subnets list --project "$PROJECT_ID" --region "$REGION" --format="value(name)")
for SUBNET_ID in $SUBNET_IDS; do
  echo "Updating $SUBNET_ID with label $LABEL_KEY:$LABEL_VALUE"
  gcloud compute networks subnets update "$SUBNET_ID" --project "$PROJECT_ID" --region "$REGION" --update-labels "$LABEL_KEY=$LABEL_VALUE"
done

# Labeling routers
echo "Processing routers..."
ROUTER_IDS=$(gcloud compute routers list --project "$PROJECT_ID" --region "$REGION" --format="value(name)")
for ROUTER_ID in $ROUTER_IDS; do
  echo "Updating $ROUTER_ID with label $LABEL_KEY:$LABEL_VALUE"
  gcloud compute routers update "$ROUTER_ID" --project "$PROJECT_ID" --region "$REGION" --update-labels "$LABEL_KEY=$LABEL_VALUE"
done

# Labeling VPN gateways
echo "Processing VPN gateways..."
VPN_GATEWAY_IDS=$(gcloud compute vpn-gateways list --project "$PROJECT_ID" --region "$REGION" --format="value(name)")
for VPN_GATEWAY_ID in $VPN_GATEWAY_IDS; do
  echo "Updating $VPN_GATEWAY_ID with label $LABEL_KEY:$LABEL_VALUE"
  gcloud compute vpn-gateways update "$VPN_GATEWAY_ID" --project "$PROJECT_ID" --region "$REGION" --update-labels "$LABEL_KEY=$LABEL_VALUE"
done

# Labeling Cloud Load Balancers
echo "Processing Cloud Load Balancers..."
LB_FORWARDING_RULE_IDS=$(gcloud compute forwarding-rules list --project "$PROJECT_ID" --format="value(name)")
for LB_FORWARDING_RULE_ID in $LB_FORWARDING_RULE_IDS; do
  echo "Updating $LB_FORWARDING_RULE_ID with label $LABEL_KEY:$LABEL_VALUE"
  gcloud compute forwarding-rules update "$LB_FORWARDING_RULE_ID" --project "$PROJECT_ID" --region "$REGION" --update-labels "$LABEL_KEY=$LABEL_VALUE"
done