#!/bin/bash

PROJECT_ID="test-functions-185602"
LABEL_KEY="purpose"
LABEL_VALUE="maintenance"

# Set the project
gcloud config set project ${PROJECT_ID}

# Label VPC networks
for network in $(gcloud compute networks list --format="value(name)")
do
  gcloud compute networks update ${network} --update-labels ${LABEL_KEY}=${LABEL_VALUE}
done

# Label subnets
for region in $(gcloud compute regions list --format="value(name)")
do
  for subnet in $(gcloud compute networks subnets list --regions ${region} --format="value(name)")
  do
    gcloud compute networks subnets update ${subnet} --region ${region} --update-labels ${LABEL_KEY}=${LABEL_VALUE}
  done
done

# Label firewall rules
for firewall in $(gcloud compute firewall-rules list --format="value(name)")
do
  gcloud compute firewall-rules update ${firewall} --update-labels ${LABEL_KEY}=${LABEL_VALUE}
done

echo "Network-related resources in project ${PROJECT_ID} have been labeled."
