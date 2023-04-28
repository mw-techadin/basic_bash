#!/bin/bash

PROJECT_ID="<your-project-id>"
LABEL_KEY="example-label"
LABEL_VALUE="example-value"
REGION="<your-region>"
ZONE="<your-zone>"

# Labeling VPC networks
echo "Processing VPC networks..."
VPC_NETWORKS=$(gcloud compute networks list --format="value(name)")
for VPC_ID in $VPC_NETWORKS; do
  echo "Updating $VPC_ID with label $LABEL_KEY:$LABEL_VALUE"
  NETWORK_DETAILS=$(gcloud compute networks describe $VPC_ID --format=json)
  FINGERPRINT=$(echo $NETWORK_DETAILS | jq -r '.labelFingerprint')
  ACCESS_TOKEN=$(gcloud auth print-access-token)
  curl -X POST -H "Authorization: Bearer $ACCESS_TOKEN" -H "Content-Type: application/json" \
    "https://compute.googleapis.com/compute/v1/projects/$PROJECT_ID/global/networks/$VPC_ID/setLabels" \
    -d "{\"labels\":{\"$LABEL_KEY\":\"$LABEL_VALUE\"},\"labelFingerprint\":\"$FINGERPRINT\"}"
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