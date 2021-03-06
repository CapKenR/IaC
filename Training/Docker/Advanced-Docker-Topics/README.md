# Advanced Docker Topics
Terraform configuration files for setting up a training lab in Azure for the Advanced Docker Topics class.

Creates the following virtual machines.
```
node-a	Ubuntu 16.04-LTS VM
node-b	Ubuntu 16.04-LTS VM
node-c	Ubuntu 16.04-LTS VM
```

Create a secret.tfvars file (ignored by Git) that looks like the following to supply your Azure credentials. (See the [Creating Credentials](https://www.terraform.io/docs/providers/azurerm/index.html#creating-credentials) section of the [Microsoft Azure Provider](https://www.terraform.io/docs/providers/azurerm/index.html) page of the Terraform documentation for details.)

```
subscription_id = "..."
client_id       = "..."
client_secret   = "..."
tenant_id       = "..."
```

The user (must be lower case) and password (for the VM's docker account) are required and have no default value. The location (defaults to "westcentralus") and environment (tag defaults to "Training") are optional variables. Variables can entered on the terraform plan/apply/destroy command line (using the -var option), supplied in a terraform.tfvars file or another .tfvars file (using the -var-file option). The user will be prompted for required variables which do not have a value.
