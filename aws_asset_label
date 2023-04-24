#!/bin/bash

AWS_PROFILE="<your-aws-profile>"
AWS_REGION="<your-aws-region>"
TAG_KEY="example-tag"
TAG_VALUE="example-value"

# Labeling EC2 instances
echo "Processing EC2 instances..."
EC2_INSTANCE_IDS=$(aws ec2 describe-instances --profile "$AWS_PROFILE" --region "$AWS_REGION" --query 'Reservations[].Instances[].InstanceId' --output text)
for INSTANCE_ID in $EC2_INSTANCE_IDS; do
  echo "Updating $INSTANCE_ID with tag $TAG_KEY:$TAG_VALUE"
  aws ec2 create-tags --profile "$AWS_PROFILE" --region "$AWS_REGION" --resources "$INSTANCE_ID" --tags "Key=$TAG_KEY,Value=$TAG_VALUE"
done

# Labeling RDS instances
echo "Processing RDS instances..."
RDS_INSTANCE_IDS=$(aws rds describe-db-instances --profile "$AWS_PROFILE" --region "$AWS_REGION" --query 'DBInstances[].DBInstanceIdentifier' --output text)
for RDS_INSTANCE_ID in $RDS_INSTANCE_IDS; do
  echo "Updating $RDS_INSTANCE_ID with tag $TAG_KEY:$TAG_VALUE"
  aws rds add-tags-to-resource --profile "$AWS_PROFILE" --region "$AWS_REGION" --resource-name "arn:aws:rds:$AWS_REGION:<your-account-id>:db:$RDS_INSTANCE_ID" --tags "Key=$TAG_KEY,Value=$TAG_VALUE"
done

# Labeling S3 buckets
echo "Processing S3 buckets..."
S3_BUCKET_NAMES=$(aws s3api list-buckets --profile "$AWS_PROFILE" --query 'Buckets[].Name' --output text)
for BUCKET_NAME in $S3_BUCKET_NAMES; do
  echo "Updating $BUCKET_NAME with tag $TAG_KEY:$TAG_VALUE"
  aws s3api put-bucket-tagging --profile "$AWS_PROFILE" --region "$AWS_REGION" --bucket "$BUCKET_NAME" --tagging "TagSet=[{Key=$TAG_KEY,Value=$TAG_VALUE}]"
done

# Labeling EBS volumes
echo "Processing EBS volumes..."
EBS_VOLUME_IDS=$(aws ec2 describe-volumes --profile "$AWS_PROFILE" --region "$AWS_REGION" --query 'Volumes[].VolumeId' --output text)
for VOLUME_ID in $EBS_VOLUME_IDS; do
  echo "Updating $VOLUME_ID with tag $TAG_KEY:$TAG_VALUE"
  aws ec2 create-tags --profile "$AWS_PROFILE" --region "$AWS_REGION" --resources "$VOLUME_ID" --tags "Key=$TAG_KEY,Value=$TAG_VALUE"
done

# Labeling Elastic Load Balancers
echo "Processing Elastic Load Balancers..."
ELB_NAMES=$(aws elb describe-load-balancers --profile "$AWS_PROFILE" --region "$AWS_REGION" --query 'LoadBalancerDescriptions[].LoadBalancerName' --output text)
for ELB_NAME in $ELB_NAMES; do
  echo "Updating $ELB_NAME with tag $TAG_KEY:$TAG_VALUE"
  aws elb add-tags --profile "$AWS_PROFILE" --region "$AWS_REGION" --load-balancer-names "$ELB_NAME" --tags "Key=$TAG_KEY,Value=$TAG_VALUE"
done

# Add more AWS services and their respective commands for tagging as needed
