#!/bin/bash

AZURE_SUBSCRIPTION_ID="<your-azure-subscription-id>"
TAG_KEY="example-tag"
TAG_VALUE="example-value"

# Labeling Virtual Machines
echo "Processing Virtual Machines..."
VM_IDS=$(az vm list --subscription "$AZURE_SUBSCRIPTION_ID" --query "[].id" --output tsv)
for VM_ID in $VM_IDS; do
  echo "Updating $VM_ID with tag $TAG_KEY:$TAG_VALUE"
  az resource tag --subscription "$AZURE_SUBSCRIPTION_ID" --ids "$VM_ID" --tags "$TAG_KEY=$TAG_VALUE"
done

# Labeling Storage Accounts
echo "Processing Storage Accounts..."
STORAGE_ACCOUNT_IDS=$(az storage account list --subscription "$AZURE_SUBSCRIPTION_ID" --query "[].id" --output tsv)
for STORAGE_ACCOUNT_ID in $STORAGE_ACCOUNT_IDS; do
  echo "Updating $STORAGE_ACCOUNT_ID with tag $TAG_KEY:$TAG_VALUE"
  az resource tag --subscription "$AZURE_SUBSCRIPTION_ID" --ids "$STORAGE_ACCOUNT_ID" --tags "$TAG_KEY=$TAG_VALUE"
done

# Labeling SQL Databases
echo "Processing SQL Databases..."
SQL_SERVER_IDS=$(az sql server list --subscription "$AZURE_SUBSCRIPTION_ID" --query "[].id" --output tsv)
for SQL_SERVER_ID in $SQL_SERVER_IDS; do
  SQL_DATABASE_IDS=$(az sql db list --subscription "$AZURE_SUBSCRIPTION_ID" --server "$SQL_SERVER_ID" --query "[].id" --output tsv)
  for SQL_DATABASE_ID in $SQL_DATABASE_IDS; do
    echo "Updating $SQL_DATABASE_ID with tag $TAG_KEY:$TAG_VALUE"
    az resource tag --subscription "$AZURE_SUBSCRIPTION_ID" --ids "$SQL_DATABASE_ID" --tags "$TAG_KEY=$TAG_VALUE"
  done
done

# Labeling Virtual Networks
echo "Processing Virtual Networks..."
VNET_IDS=$(az network vnet list --subscription "$AZURE_SUBSCRIPTION_ID" --query "[].id" --output tsv)
for VNET_ID in $VNET_IDS; do
  echo "Updating $VNET_ID with tag $TAG_KEY:$TAG_VALUE"
  az resource tag --subscription "$AZURE_SUBSCRIPTION_ID" --ids "$VNET_ID" --tags "$TAG_KEY=$TAG_VALUE"
done

# Labeling Network Interfaces
echo "Processing Network Interfaces..."
NIC_IDS=$(az network nic list --subscription "$AZURE_SUBSCRIPTION_ID" --query "[].id" --output tsv)
for NIC_ID in $NIC_IDS; do
  echo "Updating $NIC_ID with tag $TAG_KEY:$TAG_VALUE"
  az resource tag --subscription "$AZURE_SUBSCRIPTION_ID" --ids "$NIC_ID" --tags "$TAG_KEY=$TAG_VALUE"
done

# Add more Azure services and their respective commands for tagging as needed
