#!/bin/bash

# Set the variables here
age_in_days=30
cutoff_date=$(date -d "-${age_in_days} days" +%s)

echo "Deleting AWS resources older than ${age_in_days} days"

# Delete EC2 instances
echo "Deleting EC2 instances..."
aws ec2 describe-instances --query "Reservations[].Instances[?LaunchTime<=\`$(date -d "-${age_in_days} days" +%Y-%m-%dT%H:%M:%S)\`].{InstanceId: InstanceId}" --output text | while read -r instance_id; do
    echo "Deleting instance ${instance_id}"
    aws ec2 terminate-instances --instance-ids $instance_id
done

# Delete S3 buckets
echo "Deleting S3 buckets..."
aws s3api list-buckets --query "Buckets[?CreationDate<=\`$(date -d "-${age_in_days} days" +%Y-%m-%dT%H:%M:%S)\`].{Name: Name}" --output text | while read -r bucket_name; do
    echo "Deleting bucket ${bucket_name}"
    aws s3 rb "s3://${bucket_name}" --force
done

echo "Finished deleting resources."
