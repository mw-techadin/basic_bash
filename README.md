# basic_bash
General repo for Linux-related scripts and configs

The following CLI commands will be needed in order to interact with any of the 3 major cloud service providers
------------
**AWS CLI**

1. `aws configure`: Configures your AWS CLI with access key, secret key, default region, and output format. You can also set these values individually using the `--profile` flag to manage multiple profiles.

```
aws configure [--profile profile-name]
```

2. `aws sts get-caller-identity`: Returns details about the IAM user or role whose credentials are used to call the operation.

3. `aws configure list`: Lists all the configuration settings, including the access key, secret key, default region, and output format.

4. `aws configure list-profiles`: Lists all the profiles in the AWS CLI config file.

5. `aws configure get`: Retrieves the value of a specific configuration item.

```
aws configure get aws_access_key_id [--profile profile-name]
```

6. `aws configure set`: Sets the value of a specific configuration item.

```
aws configure set aws_access_key_id NEW_ACCESS_KEY [--profile profile-name]
```
------------
**Azure CLI**

1. `az login`: Interactively logs in and sets your Azure account as the active account. It opens a web page for you to sign in and grant permission to the Azure CLI.

```
az login
```

2. `az account list`: Lists all the accounts that you have access to and shows the currently active account.

```
az account list [--output table]
```

3. `az account set`: Sets the active subscription.

```
az account set --subscription "Your_Subscription_Name_or_ID"
```

4. `az logout`: Logs out the active user.

```
az logout
```

5. `az ad signed-in-user show`: Displays information about the signed-in user.

6. `az ad sp create-for-rbac`: Creates a service principal and assigns a role to it.

```
az ad sp create-for-rbac --name ServicePrincipalName --role Contributor
```

7. `az login --service-principal`: Logs in with a service principal using a client secret.

```
az login --service-principal -u CLIENT_ID -p CLIENT_SECRET --tenant TENANT_ID
```
------------
**Google SDK**

1. `gcloud auth login`: Interactively authenticates your Google Cloud account and sets it as the active account. It opens a web page for you to sign in and grant permission to the Google Cloud SDK.

2. `gcloud auth list`: Lists the accounts that have been authenticated and shows the currently active account.

3. `gcloud auth activate-service-account`: Activates a service account with the specified key file and sets it as the active account. You need to provide the service account email address and the path to the key file in JSON format. Example usage:

```
gcloud auth activate-service-account --key-file=/path/to/keyfile.json my-service-account@myproject.iam.gserviceaccount.com
```

4. `gcloud auth revoke`: Revokes credentials for a specified account. If no account is provided, it revokes the credentials for the active account.

5. `gcloud auth application-default login`: Interactively authenticates your Google Cloud account and sets the application default credentials. This is useful for local development and testing, as it lets you use the same credentials that your application would use when deployed on Google Cloud.

6. `gcloud auth application-default revoke`: Revokes the application default credentials.

7. `gcloud auth print-access-token`: Prints an access token for the active account. This can be useful for making authenticated API requests.

8. `gcloud auth print-identity-token`: Prints an OpenID Connect identity token for the active account. This can be useful for making authenticated API requests to services that accept identity tokens.

- AWS CLI: https://aws.amazon.com/cli/
- Azure CLI: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
- Google Cloud SDK: Please note that you need to have the Google Cloud SDK installed on your system to use these commands. You can find the installation instructions here: https://cloud.google.com/sdk/docs/install
