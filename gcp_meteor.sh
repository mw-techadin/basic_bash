#!/bin/bash

# Set the variables here
age_in_days=2
project_id="test-functions-185602"

# Set the cutoff_date based on the operating system
if [[ "$OSTYPE" == "darwin"* ]]; then
    cutoff_date=$(date -j -v -${age_in_days}d +%Y-%m-%dT%H:%M:%S)
else
    cutoff_date=$(date -d "-${age_in_days} days" +%Y-%m-%dT%H:%M:%S)
fi

echo "Deleting resources older than ${cutoff_date} in project ${project_id}"

# Delete Compute Engine instances
echo "Deleting Compute Engine instances..."
gcloud compute instances list --project $project_id --filter="creationTimestamp<${cutoff_date}" --format="value(name,zone)" | while read -r instance zone; do
    echo "Deleting instance ${instance} in zone ${zone}"
    gcloud compute instances delete $instance --project $project_id --zone $zone --quiet
done

# Delete Cloud Storage buckets
echo "Deleting Cloud Storage buckets..."
gsutil ls -p $project_id | while read -r bucket; do
    creation_time=$(gsutil ls -L -p $project_id $bucket | grep "Creation time:" | awk -F: '{print $2}' | xargs)
    if [ "$(date -d "$creation_time" +%Y-%m-%dT%H:%M:%S 2>/dev/null || date -j -f "%a %b %d %T %Z %Y" "$creation_time" +%Y-%m-%dT%H:%M:%S)" \< "$cutoff_date" ]; then
        echo "Deleting bucket ${bucket}"
        gsutil rm -r $bucket
    fi
done

# Delete BigQuery datasets
echo "Deleting BigQuery datasets..."
bq ls --project_id $project_id --format="csv" | tail -n +3 | while read -r dataset; do
    creation_time=$(bq show --project_id $project_id --format="json" $dataset | jq -r '.creationTime' | xargs)
    creation_time=$(date -d "@$(($creation_time/1000))" +%Y-%m-%dT%H:%M:%S 2>/dev/null || date -j -f "%s" $(($creation_time/1000)) +%Y-%m-%dT%H:%M:%S)
    if [ "$creation_time" \< "$cutoff_date" ]; then
        echo "Deleting dataset ${dataset}"
        bq rm -r -f --project_id $project_id $dataset
    fi
done

echo "Finished deleting resources."
