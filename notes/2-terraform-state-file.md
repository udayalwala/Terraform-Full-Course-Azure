✅ Terraform state file

A Terraform state file ( .tfstate extension) is a file that stores the configurations of the infrastructure that has been created. 

The actual state is tracked in a special file called the Terraform state file (terraform.tfstate)

It records the current state of your infrastructure resources (e.g., resource IDs, names, configurations).Its should NEVER be modified manually.

It's critical for planning, change detection, and tracking drift between desired and actual resources.

🔹 How It Works (Behind the Scenes)

During terraform init:
Terraform connects to the configured Azure Blob container.

If a state file exists, it uses it. If not, it creates a new one.

During terraform apply:
Terraform refreshes the remote state.

Compares it to the desired state in your configuration.

Applies the changes and updates the remote state file in Azure.

🛑 State Locking:
A temporary lock file is created to prevent parallel modifications.


# ----------------------------------------
# 🌐 Terraform Remote Backend Setup Script
# ----------------------------------------
# Creates an Azure Resource Group, Storage Account, and Blob Container
# for storing Terraform state remotely.

# 🔧 Configuration

```
RESOURCE_GROUP_NAME="tfstate-day04"
STORAGE_ACCOUNT_NAME="day04$RANDOM"   # Random suffix to avoid name conflicts
CONTAINER_NAME="tfstate"
LOCATION="eastus"

echo "📁 Creating Resource Group: $RESOURCE_GROUP_NAME..."
az group create \
  --name "$RESOURCE_GROUP_NAME" \
  --location "$LOCATION"

echo "💾 Creating Storage Account: $STORAGE_ACCOUNT_NAME..."
az storage account create \
  --resource-group "$RESOURCE_GROUP_NAME" \
  --name "$STORAGE_ACCOUNT_NAME" \
  --sku Standard_LRS \
  --encryption-services blob

echo "📦 Creating Blob Container: $CONTAINER_NAME..."
az storage container create \
  --name "$CONTAINER_NAME" \
  --account-name "$STORAGE_ACCOUNT_NAME"

echo " Terraform backend storage setup completed!"
```

example for connecting to Azure backend:

```
 backend "azurerm" {
    resource_group_name  = "tfstate-day04"  # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
    storage_account_name = "day0417691"                      # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "tfstate"                       # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "dev.terraform.tfstate"        # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  }
  ```

   Why Use Remote Backend in Azure? Using an Azure Storage Account as a backend offers several advantages:

🧠 Centralized State The state file is accessible to all team members working on the same infrastructure. 

🔒 Secure Storage Azure automatically encrypts data at rest. Access is controlled via RBAC or shared access tokens. 

🔄 State Locking Azure supports state locking to prevent race conditions during concurrent operations. 

📜 Versioning Blob versioning (if enabled) allows you to recover previous states. 

🤝 Collaboration Enables multiple users to safely work on the same infrastructure without state conflicts