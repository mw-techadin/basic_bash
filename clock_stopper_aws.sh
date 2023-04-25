#!/bin/bash

# Set the threshold (in minutes) for instances to be stopped
THRESHOLD_MINUTES=60

# Get the current timestamp
CURRENT_TIMESTAMP=$(date +%s)

# List all running EC2 instances and their launch times
aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId, LaunchTime]' --filters Name=instance-state-name,Values=running --output text > instances.txt

# Iterate through instances and check if they have been running longer than the threshold
while read -r INSTANCE; do
  INSTANCE_ID=$(echo "$INSTANCE" | awk '{print $1}')
  INSTANCE_LAUNCH_TIME=$(echo "$INSTANCE" | awk '{print $2}')
  INSTANCE_TIMESTAMP=$(date --date="$INSTANCE_LAUNCH_TIME" +%s)

  # Calculate the duration in minutes
  DURATION_MINUTES=$(( (CURRENT_TIMESTAMP - INSTANCE_TIMESTAMP) / 60 ))

  # Check if the duration exceeds the threshold
  if [ "$DURATION_MINUTES" -gt "$THRESHOLD_MINUTES" ]; then
    echo "Stopping instance $INSTANCE_ID, running for $DURATION_MINUTES minutes."
    aws ec2 stop-instances --instance-ids "$INSTANCE_ID"
  else
    echo "Instance $INSTANCE_ID is within threshold, running for $DURATION_MINUTES minutes."
  fi
done < instances.txt

# Cleanup
rm instances.txt
