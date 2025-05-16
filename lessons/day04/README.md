# Day04 - Terraform State File

## How Terraform update Infrastructure

- Goal is to keep the actual state same as the desired state
- The actual state resides inside a file called statefile
  
<img width="618" alt="image" src="https://github.com/user-attachments/assets/66582b79-fd7f-41b7-b287-974319bef8d8" />

## State file best practices

<img width="587" alt="image" src="https://github.com/user-attachments/assets/7e0b774f-bf83-4576-b8e8-618ee248f8f7" />

## Assignment for day04

- Create Azure resources such as resource group and storage account using a remote backend


Terraform State in Azure Remote Backend – Description
Terraform maintains a state file that tracks the current state of infrastructure resources. When you use a remote backend like Azure Storage, Terraform does not store this state locally; instead, it saves it centrally in Azure.

🔹 What Is Stored?
The Terraform state file (terraform.tfstate) contains the actual state of the resources created — including names, IDs, configurations, and sometimes sensitive outputs.

This file represents the actual state of your infrastructure, against which Terraform compares your code (the desired state) to determine what changes are needed.

🔹 Why Use Remote Backend in Azure?
Using an Azure Storage Account as a backend offers several advantages:

Feature	Benefit
🧠 Centralized State	The state file is accessible to all team members working on the same infrastructure.
🔒 Secure Storage	Azure automatically encrypts data at rest. Access is controlled via RBAC or shared access tokens.
🔄 State Locking	Azure supports state locking to prevent race conditions during concurrent operations.
📜 Versioning	Blob versioning (if enabled) allows you to recover previous states.
🤝 Collaboration	Enables multiple users to safely work on the same infrastructure without state conflicts.

🔹 How It Works (Behind the Scenes)
During terraform init:

Terraform connects to the Azure Blob container defined in the backend config.

It verifies if a state file exists; if yes, it uses it. If not, it creates one.

During terraform apply:

Terraform refreshes the current state from Azure.

It compares this with the desired state from your code.

After applying changes, it updates the remote state file in Azure.

State Locking:

A lock file is temporarily created to prevent parallel state modifications.

🛡️ Summary
Terraform uses Azure Blob Storage as a remote, secure, shared source of truth for infrastructure state. This ensures consistency, enables collaboration, and supports safe automation workflows.
