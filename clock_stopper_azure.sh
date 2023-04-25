#!/bin/bash

# Set the threshold (in minutes) for instances to be stopped
THRESHOLD_MINUTES=60

# Get the current timestamp
CURRENT_TIMESTAMP=$(date +%s)

# List all running VMs and their creation timestamps
az vm list --show-details --query "[?powerState=='VM running'].{id: id, created: creationTimestamp}" -o tsv > instances.tsv

# Iterate through instances and check if they have been running longer than the threshold
while read -r INSTANCE; do
  INSTANCE_ID=$(echo "$INSTANCE" | awk '{print $1}')
  INSTANCE_TIMESTAMP=$(echo "$INSTANCE" | awk '{print $2}')
  INSTANCE_CREATION_TIMESTAMP=$(date --date="$INSTANCE_TIMESTAMP" +%s)

  # Calculate the duration in minutes
  DURATION_MINUTES=$(( (CURRENT_TIMESTAMP - INSTANCE_CREATION_TIMESTAMP) / 60 ))

  # Check if the duration exceeds the threshold
  if [ "$DURATION_MINUTES" -gt "$THRESHOLD_MINUTES" ]; then
    echo "Stopping instance $INSTANCE_ID, running for $DURATION_MINUTES minutes."
    az vm stop --ids "$INSTANCE_ID"
  else
    echo "Instance $INSTANCE_ID is within threshold, running for $DURATION_MINUTES minutes."
  fi
done < instances.tsv

# Cleanup
rm instances.tsv
