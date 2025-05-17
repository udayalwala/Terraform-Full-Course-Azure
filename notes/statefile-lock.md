🔐 Handling Locked Terraform State in Azure
If your Terraform state file is locked, you must remove the lock before running terraform apply.

🔑 Step 1: Get the Storage Account Key

```
az storage account keys list \
  --resource-group tfstatefilesrg \
  --account-name tfstatefilesc \
  --query "[0].value" \
  --output tsv
```
This command retrieves the primary access key for your Azure Storage Account.

🔓 Step 2: Break the Lease (Unlock the State File)
Use the key retrieved above to remove the lock on the state file:

```
az storage blob lease break \
  --account-key <your-storage-account-key> \
  --account-name tfstatefilesc \
  --blob-name demo.terraform.tfstate \
  --container-name tfstate
```
Replace <your-storage-account-key> with the value obtained in Step 1.

💡 Parameter Reference

--account-name: Name of your Azure Storage Account

Example: tfstatefilesc

--container-name: The container inside the storage account (like a folder)

Example: tfstate

--blob-name: The state file stored inside the container

Example: demo.terraform.tfstate

