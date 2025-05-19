## Terraform Notes
## What is terraform?
Terraform is an open-source Infrastructure as Code (IaC) tool developed by HashiCorp. It allows you to define, provision, and manage infrastructure using a high-level configuration language called HashiCorp Configuration Language (HCL) or optionally JSON.

## Key Features:
Infrastructure as Code (IaC): You write code to define cloud and on-prem resources like VMs, networks, databases, etc.

Platform Agnostic: Works with many providers such as AWS, Azure, Google Cloud, VMware, and even on-prem tools via plugins called providers. You can write the same infrastructure-as-code logic to manage multi-cloud or hybrid-cloud environments without switching tools.

Declarative Language: You declare what infrastructure you want, and Terraform figures out how to create/update/delete it.

Execution Plan: Shows what actions will be taken before making any changes, reducing the risk of errors.
State Management: Maintains a state file to track real-world resource states and detect drift.

## Common Terraform Commands / terraform lifecycle: 
### terraform init -
 Initiating all configuration files, backends and cloud platform.
It will create a hidden directory called .terraform which contains terraform artifactory for cloud providers.
It will also create .terraform.lock.hcl file that prevents infra duplication.
### terraform plan – 
this command will show you the complete blueprints, what you are going to creating or modifying on cloud.
### terraform apply – 
This command will execute/deploy all terraform files that will create your infrastructure on cloud.
This will create the most important file that contains all the information of your created infrastructure called terraform.tfstate.
### terraform destroy – 
This command will delete all the created infrastructure
Terraform refers terraform.tfstate file to check all infra and then delete that infra.

## What is the difference between variables.tf and terraform .tfvars?
### variables.tf file:(declaration)
It declares input variables that can be used throughout your Terraform configuration.
It contains Variable names, types, default values, and descriptions.
It is not compulsory for the variable block to be present in variables.tf file. It can be present in any tf file. 

Example:
```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
```
### terraform.tfvars:(assignment)
It provides actual values for the variables declared in variables.tf.
It is used for assigning or overriding values during execution.
Example:
```hcl
instance_type = "t3.small"
```

## .terraform.lock.hcl file:
The .terraform.lock.hcl file is automatically created and updated by Terraform during terraform init. It records exact provider versions, registries, and checksums to ensure consistent and secure dependency management.
It's recommended to include the lock file in your version control repository to ensure that everyone on your team uses the same provider versions. 

## .terraform folder:
The .terraform folder in a Terraform project is a hidden directory where Terraform stores local, temporary files and configurations that are not intended for version control. It's created when you initialize a Terraform project using the terraform init command.

It can include:

<b>Plugin binaries:</b> Providers (e.g., aws, azurerm) that Terraform downloads.

<b>Module cache:</b> Cached versions of modules you've used (especially remote ones).

<b>Terraform state backup:</b> Temporary or local backups of your .tfstate file (depending on the backend).

<b>Environment data:</b> When using workspaces, it may store data specific to them.

## What is terraform.tfstate?
The terraform.tfstate file in Terraform is a  JSON-formatted file that stores the state of your infrastructure, mapping your configuration to the resources created in your cloud provider.
It is an important file which contains information about the infrastructure that you have created.
By default, it's stored locally in the root directory of your Terraform project as a JSON file named terraform.tfstate. But for collaboration purposes it is securely stored on s3 or dynamoDB service of aws.
It should be added to .gitignore.

## What is terraform.tfstate.backup?
The terraform.tfstate.backup file is an automatic backup of the previous terraform.tfstate file that Terraform creates each time you run a command that modifies the state, such as:
```
terraform apply
```
```
terraform destroy
```
If something goes wrong during the state update (like an error in resource creation), this backup can help you recover.
If your terraform.tfstate file becomes corrupted or unusable, you can manually recover the backup.
```
cp terraform.tfstate.backup terraform.tfstate
```
This tells Terraform to revert to the previous state.


## Modules:
A module is a container for multiple resources that are used together. Modules help organize and reuse code in a clean, maintainable, and scalable way.

#### Modules can be:

Root module: Your main Terraform configuration (the directory where you run terraform apply).

Child module: A module that is called from another module using the module block.

### Why Use Modules?
Reusability: Write once, use many times.

Organization: Break large configs into manageable parts.

Maintainability: Easier updates and changes.

Abstraction: Hide implementation details and expose inputs/outputs.

### Example:
Suppose you have a child module in a folder modules/s3_bucket:

modules/s3_bucket/main.tf
```hcl
resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name
  acl    = "private"
}
```
modules/s3_bucket/variables.tf
```hcl
variable "bucket_name" {
  type = string
}
```
Root module (main.tf)
```hcl
module "my_bucket" {
  source      = "./modules/s3_bucket"
  bucket_name = var.bucket_name
}
```
Root module (variable.tf)
```hcl
variable "bucket_name" {
  default = "my-app-bucket"
}
```

## Provisioners:
Provisioners in Terraform are used to execute scripts or commands on a local machine or a remote resource (like an EC2 instance) after it is created or destroyed.

### Types of provisioners:
file: Copies files or directories to the remote machine.

local-exec: Runs a command on the machine where Terraform is run.

remote-exec: Runs a command on the remote resource via SSH or WinRM.

## Terraform import:
terraform import — (Bringing Existing Infrastructure into Terraform)

The terraform import command is used to bring existing cloud resources (e.g., AWS EC2, S3, etc.) under Terraform management without recreating them.

### Why Use terraform import?
- Manage manually created or legacy infrastructure using Terraform.
- Avoid destroying/recreating live resources.
- Start infrastructure as code (IaC) with existing setups.

### Syntax:
```
terraform import <RESOURCE_TYPE.REFERENCE_NAME> <RESOURCE_ID>
```
### Example:
Suppose you have an EC2 instance with ID i-0abcd1234ef56789.

Define the resource in your .tf file:
```hcl
resource "aws_instance" "example" {
  # Leave empty for now, will populate after import
}
```

### Import the resource:
```hcl
terraform import aws_instance.example i-0abcd1234ef56789
```
Run terraform plan to inspect the state and then update the .tf file to match the imported resource.
### Notes:
- Import adds the resource to Terraform's state, but not automatically to .tf files.
- You must manually write the configuration to match the imported resource.
- You can only import one resource at a time (but automation scripts can help).
- If the .tf configuration doesn't match the actual resource, Terraform may try to change or recreate it.


## Why is Terraform State Locking important?-
It prevents Terraform state file(terraform.tfstate) from accidental updates by putting a lock on file so that the current update can be finished before processing the new change. The feature of Terraform state locking is supported by AWS S3 and DynamoDB.
