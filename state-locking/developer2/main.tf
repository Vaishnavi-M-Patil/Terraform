#terraform block
terraform {
  backend "s3" {
    bucket="terraform-backend-1283"                 # bucket name
    region = "us-east-1"                            #bucket region
    key = "backend/terraform.tfstate"               #path of state file on s3
    dynamodb_table = "state-locking-table"          #dynamodb table name
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
