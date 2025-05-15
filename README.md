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
## Ans:
### variables.tf file:(declaration)
It declares input variables that can be used throughout your Terraform configuration.
It contains Variable names, types, default values, and descriptions.
It is not compulsory for the variable block to be present in variables.tf file. It can be present in any tf file. 
Example:
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

### terraform.tfvars:(assignment)
It provides actual values for the variables declared in variables.tf.
It is used for assigning or overriding values during execution.
Example:
instance_type = "t3.small"

