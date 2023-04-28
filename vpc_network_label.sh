import subprocess
import json
from google.cloud import compute_v1

PROJECT_ID = "YOUR_PROJECT_ID"
LABEL_KEY = "your_label_key"
LABEL_VALUE = "network_resource"

# Set the project
subprocess.run(["gcloud", "config", "set", "project", PROJECT_ID])

client = compute_v1.SubnetworksClient()

# Label subnets
regions = [region.name for region in client.list_regions(project=PROJECT_ID)]
for region in regions:
    for subnetwork in client.list(project=PROJECT_ID, region=region):
        subnetwork_name = subnetwork.name
        current_labels = subnetwork.labels

        # If the current labels are empty, set them to the desired key-value pair
        if not current_labels:
            updated_labels = {LABEL_KEY: LABEL_VALUE}
        else:
            # Else, append the desired key-value pair to the existing labels
            updated_labels = {**current_labels, LABEL_KEY: LABEL_VALUE}

        subnetwork.labels = updated_labels
        operation = client.patch(project=PROJECT_ID, region=region, subnetwork=subnetwork_name, subnetwork_resource=subnetwork)
        operation.result()

# Label firewall rules
firewall_rules = compute_v1.FirewallsClient()
for firewall_rule in firewall_rules.list(project=PROJECT_ID):
    firewall_name = firewall_rule.name
    current_labels = firewall_rule.labels

    # If the current labels are empty, set them to the desired key-value pair
    if not current_labels:
        updated_labels = {LABEL_KEY: LABEL_VALUE}
    else:
        # Else, append the desired key-value pair to the existing labels
        updated_labels = {**current_labels, LABEL_KEY: LABEL_VALUE}

    firewall_rule.labels = updated_labels
    operation = firewall_rules.patch(project=PROJECT_ID, firewall=firewall_name, firewall_resource=firewall_rule)
    operation.result()

print(f"Network-related resources in project {PROJECT_ID} have been labeled.")
