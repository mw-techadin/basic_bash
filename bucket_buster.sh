#!/bin/bash

PROJECT_ID="test-functions-185602"
LABEL_KEY="purpose"
LABEL_VALUE="test"
REGION="us-central1"

echo "Processing Google Cloud Storage buckets..."

BUCKETS=$(gsutil ls -p $PROJECT_ID)

for BUCKET in $BUCKETS; do
  echo "Updating $BUCKET with label $LABEL_KEY:$LABEL_VALUE"
  CURRENT_LABELS=$(gsutil label get $BUCKET)
  
  # Remove the outermost curly braces
  CURRENT_LABELS=$(echo $CURRENT_LABELS | sed 's/^{//;s/}$//')
  
  # If there are existing labels, append the new label
  if [[ -n $CURRENT_LABELS ]]; then
    UPDATED_LABELS="{$CURRENT_LABELS, \"$LABEL_KEY\":\"$LABEL_VALUE\"}"
  else
    UPDATED_LABELS="{\"$LABEL_KEY\":\"$LABEL_VALUE\"}"
  fi

  gsutil label set "$UPDATED_LABELS" $BUCKET
done

echo "Google Cloud Storage bucket label update completed."
