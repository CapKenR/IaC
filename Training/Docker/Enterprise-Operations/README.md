# Docker Enterprise Operations
Terraform configuration files for setting up a training lab in Azure for the Docker Enterprise Operations class.

Creates the following virtual machines.
```
ucp-controller	UCP and DTR manager, Ubuntu 16.04-LTS VM with Docker CE installed
ucp-manager-0	UCP and DTR manager, Ubuntu 16.04-LTS VM with Docker CE installed
ucp-manager-1	UCP and DTR manager, Ubuntu 16.04-LTS VM with Docker CE installed
ucp-node-0	UCP worker, Ubuntu 16.04-LTS VM with Docker CE installed
ucp-node-1	UCP worker, Ubuntu 16.04-LTS VM with Docker CE installed
```

Create a secret.tfvars file (ignored by Git) that looks like the following to supply your Azure credentials. (See the [Creating Credentials](https://www.terraform.io/docs/providers/azurerm/index.html#creating-credentials) section of the [Microsoft Azure Provider](https://www.terraform.io/docs/providers/azurerm/index.html) page of the Terraform documentation for details.)

```
subscription_id = "..."
client_id       = "..."
client_secret   = "..."
tenant_id       = "..."
```

The user (must be lower case) and password (for the VM's docker account) are required and have no default value. The location (defaults to "westcentralus") and environment (tag defaults to "Training") are optional variables. Variables can entered on the terraform plan/apply/destroy command line (using the -var option), supplied in a terraform.tfvars file or another .tfvars file (using the -var-file option). The user will be prompted for required variables which do not have a value.
