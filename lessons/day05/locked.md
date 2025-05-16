#If you state file is locked 

remove the lock beforeyou execute the terraform apply

to get the key list
======================
az storage account keys list \
  --resource-group tfstatefilesrg \
  --account-name tfstatefilesc \
  --query "[0].value" \
  --output tsv




  remove the lock using key displayed from above output:
  =======================================================
  az storage blob lease break --account-key <secreykeyvaluetobepassed> --account-name tfstatefilesc --blob-name demo.terraform.tfstate --container-name tfstate
  
  --account-name — This is the name of the Azure Storage Account. It’s the top-level storage resource that holds containers and blobs. For example, if your storage account is named mystorageaccount, you'd specify that here.

--container-name — This refers to the container inside the storage account. Think of it like a folder inside the storage account where blobs (files) are stored. For example, tfstate or statefiles.

--blob-name — This is the specific blob (file) inside the container. For Terraform, this is usually the state file like terraform.tfstate or any custom name you gave it (e.g., demo.terraform.tfstate).
  
