# Azure Terraform Cloud No-Code Infrastructure

This repo provides reusable Terraform modules for Azure Network + VM, wrapped into a No-Code provisioning module for Terraform Cloud.

## Structure
- modules/network → VNet, Subnets, NSGs, Public IPs
- modules/vm      → Linux/Windows VMs
- no-code-infra   → No-Code wrapper combining both

## Steps to Use
1. Create Azure Service Principal:
   ```bash
   az ad sp create-for-rbac --name "tfc-no-code" --role Contributor --scopes /subscriptions/<SUBSCRIPTION_ID>
   ```
   Save values into Terraform Cloud Environment Variables:
   - ARM_CLIENT_ID
   - ARM_CLIENT_SECRET
   - ARM_SUBSCRIPTION_ID
   - ARM_TENANT_ID

2. Push repo to GitHub and tag:
   ```bash
   git add . && git commit -m "initial" && git push
   git tag v1.0.0 && git push origin v1.0.0
   ```

3. Publish module in Terraform Cloud Registry → choose subdirectory `no-code-infra`.

4. Create Workspace (No-Code Provisioning) → Select module → Fill variables:
   ```hcl
   prefix       = "myapp"
   environment  = "dev"
   location     = "eastus"
   vm_count     = 1
   os_type      = "linux"
   admin_username = "azureuser"
   admin_ssh_public_key = "ssh-rsa AAA..."
   ```

5. Run plan & apply → Network + VM provisioned together.
