#!/bin/bash

# Set the threshold (in minutes) for instances to be stopped
THRESHOLD_MINUTES=60

# Get the current timestamp
CURRENT_TIMESTAMP=$(date +%s)

# List all instances in the project and their creation timestamps
gcloud compute instances list --format='csv[no-heading](name,zone,creationTimestamp.date("%s"))' --filter="status=RUNNING" > instances.csv

# Iterate through instances and check if they have been running longer than the threshold
while read -r INSTANCE; do
  INSTANCE_NAME=$(echo "$INSTANCE" | awk -F',' '{print $1}')
  INSTANCE_ZONE=$(echo "$INSTANCE" | awk -F',' '{print $2}')
  INSTANCE_TIMESTAMP=$(echo "$INSTANCE" | awk -F',' '{print $3}')

  # Calculate the duration in minutes
  DURATION_MINUTES=$(( (CURRENT_TIMESTAMP - INSTANCE_TIMESTAMP) / 60 ))

  # Check if the duration exceeds the threshold
  if [ "$DURATION_MINUTES" -gt "$THRESHOLD_MINUTES" ]; then
    echo "Stopping instance $INSTANCE_NAME in zone $INSTANCE_ZONE, running for $DURATION_MINUTES minutes."
    gcloud compute instances stop "$INSTANCE_NAME" --zone="$INSTANCE_ZONE"
  else
    echo "Instance $INSTANCE_NAME in zone $INSTANCE_ZONE is within threshold, running for $DURATION_MINUTES minutes."
  fi
done < instances.csv

# Cleanup
rm instances.csv
