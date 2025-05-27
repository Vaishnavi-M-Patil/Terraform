# Terraform
## What is terraform?
Terraform is an open-source Infrastructure as Code (IaC) tool developed by HashiCorp. It allows you to define, provision, and manage infrastructure using a high-level configuration language called HashiCorp Configuration Language (HCL) or optionally JSON.

## Key Features:
- **Infrastructure as Code (IaC):** You write code to define cloud and on-prem resources like VMs, networks, databases, etc.

- **Platform Agnostic:** Works with many providers such as AWS, Azure, Google Cloud, VMware, and even on-prem tools via plugins called providers. You can write the same infrastructure-as-code logic to manage multi-cloud or hybrid-cloud environments without switching tools.

- **Declarative Language:** You declare what infrastructure you want, and Terraform figures out how to create/update/delete it.

- **Execution Plan:** Shows what actions will be taken before making any changes, reducing the risk of errors.

- **State Management:** Maintains a state file to track real-world resource states and detect drift.

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

**Example:**
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
**Example:**
```hcl
instance_type = "t3.small"
```

## .terraform.lock.hcl file:
The .terraform.lock.hcl file is automatically created and updated by Terraform during terraform init. It records exact provider versions, registries, and checksums to ensure consistent and secure dependency management.
It's recommended to include the lock file in your version control repository to ensure that everyone on your team uses the same provider versions. 

## .terraform folder:
The .terraform folder in a Terraform project is a hidden directory where Terraform stores local, temporary files and configurations that are not intended for version control. It's created when you initialize a Terraform project using the terraform init command.

It can include:

- **Plugin binaries:** Providers (e.g., aws, azurerm) that Terraform downloads.

- **Module cache:** Cached versions of modules you've used (especially remote ones).

- **Terraform state backup:** Temporary or local backups of your .tfstate file (depending on the backend).

- **Environment data:** When using workspaces, it may store data specific to them.

## What is terraform.tfstate?
The terraform.tfstate file in Terraform is a JSON-formatted file that stores the state of your infrastructure, mapping your configuration to the resources created in your cloud provider.
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

- **Root module:** Your main Terraform configuration (the directory where you run terraform apply).

- **Child module:** A module that is called from another module using the module block.

### Why Use Modules?
- **Reusability:** Write once, use many times.

- **Organization:** Break large configs into manageable parts.

- **Maintainability:** Easier updates and changes.

- **Abstraction:** Hide implementation details and expose inputs/outputs.

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
- **file:** Copies files or directories to the remote machine.

- **local-exec:** Runs a command on the machine where Terraform is run.

- **remote-exec:** Runs a command on the remote resource via SSH or WinRM.

## Terraform import:
**terraform import** — (Bringing Existing Infrastructure into Terraform)

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
Q. State two use cases where you would use terraform import
   - You have existing resources in one of the providers and they are not managed by Terraform (as in not included in the state)
    - You lost your tfstate file and need to rebuild it

## terraform init -reconfigure:
- It is used to force reinitialization of the Terraform backend.
- It is required when you change backend settings manually.

## Backend block inside terraform block:
```hcl
terraform {
  backend "s3" {
    bucket = aws_s3_bucket.buckets3.bucket  # ❌ Not allowed
    key    = "state/terraform.tfstate"
    region = "us-east-1"
  }
}
```

- The terraform { backend {} } block configures where Terraform stores state (e.g., S3, local, etc.).
- Backend configuration must use only static values — no variables, no resource references, and no expressions.
- This is because Terraform loads the backend before evaluating the rest of the configuration (providers/resources).
```hcl
This is the correct way of backend block:
terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket"
    key    = "env/dev/terraform.tfstate"
    region = "us-east-1"
  }
}
```

## What is a data block in Terraform?
In Terraform, a data block is used to read or fetch existing resources that were not created by your Terraform configuration, but that you want to reference or use.


## Terraform State Locking using DynamoDB

Terraform state is the backbone of terraform project for provisioning cloud infrastructure. When we work on large infrastructure provisioning with Terraform then it is always more than one developer or team of a developer working on the same terraform project.

The problems arise when two developers try to update the same terraform state file which is stored remotely(S3 Bucket). Ideally, the update on the state file should be done incrementally so that when one developer finishes pushing its state file changes another developer can push their changes after taking the update.

But because of the agile working environment, we can not guarantee that incremental updates on terraform state files will be performed one after another. Any developer can update and push terraform state file at any point in time, so there should be some provision to prevent a developer from writing or updating terraform file when it is already being used by another developer.

**Why Terraform State Locking is important?-** It prevents Terraform state file(terraform.tfstate) from accidental updates by putting a lock on file so that the current update can be finished before processing the new change. The feature of Terraform state locking is supported by AWS S3 and Dynamo DB.

### Steps:
### 1. How to store Terraform state file remotely on S3?
Provision an EC2 instance using Terraform and store the Terraform state file (terraform.tfstate) remotely in an S3 bucket.
```hcl
terraform {
    backend "s3" {
        bucket = "terraform-backend-1283"
        region = "us-east-1"
        key = "backend/terraform.tfstate"     # path of tfstate file stored in s3
    }
}
```

### 2. Create DynamoDB table on AWS
1. Goto your AWS management console and search for DynamoDB onto the search bar.
2. Click on the DynamoDB
3. From the left navigation panel click on Tables
4. Click on Create Table
5. Enter the Table name - "state-lock" and Partition Key - "LockID"
6. Click on Create Table and you can verify the table after the creation

### 3. Add AWS DynamoDB Table reference to Backend S3 remote state?
After creating the DynamoDB table in the previous step, let's add the reference of DynamoDB table name (state_lock) to backend.

Your final Terraform project1/main.tf should look like this -
```hcl
terraform {
    backend "s3" {
        bucket = "terraform-backend-1283"
        region = "us-east-1"
        key = "backend/terraform.tfstate"     
        dynamodb_table = "state_lock" 
    }
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "ec2-instance" {
    ami = "ami-0953476d60561c955"
    instance_type = "t2.micro"
    key_name = "vir-key"
    tags = {
      Name = "ec2 instance- developer1"
    }
}
```

### 4. Spin one more EC2 instance with same terraform state file
To test terraform state locking I will provision one more EC2 machine using the same Terraform state file (backend/terraform.tfstate) stored in my S3 bucket along with the same DynamoDB table (state_lock).

we are still using following two components from previous main.tf:

**S3 Bucket -** terraform-backend-1283

**DynamoDB Table -** state_lock

**Terraform state file -** backend/terraform.tfstate

Here is my another project1/main.tf file -
```hcl
terraform {
    backend "s3" {
        bucket = "terraform-backend-1283"
        region = "us-east-1"
        key = "backend/terraform.tfstate"     
        dynamodb_table = "state_lock" 
    }
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "ec2-instance" {
    ami = "ami-0953476d60561c955"
    instance_type = "t2.micro"
    key_name = "vir-key"
    tags = {
      Name = "ec2 instance- developer2"
    }
}
```
Run both the terraform files at the same time to simulate the Locking on terraforming state file

#### Simulate Terraform State Locking
1. Open two terminals in the same Terraform project.(one for 'project1' and another for 'project2')
3. In Terminal 1, run terraform apply and pause at the approval step.
4. In Terminal 2, try running any Terraform command like plan or apply.
5. Result: Terminal 2 will show a state lock message, as only one process can modify the infrastructure at a time.

### 5. Conclusion:
Terraform state file locking is one of the most valuable features for managing the Terraform state file. When using AWS S3 for remote state storage combined with DynamoDB for state locking, Terraform ensures safer state management by preventing concurrent modifications.

