terraform {
  backend "s3" {
    bucket = "terraform-backend-1283"
    region = "us-east-1"
    key = "terraform.tfstate"
  }
}

module "myvpc" {
  source = "./vpc"
  vpc_cidr = var.vpc_cidr
  pvt_cidr = var.pvt_cidr
  pub_cidr = var.pub_cidr
}

module "ec2instance" {
  source = "./instance"
  instanceType = var.instanceType
  ami = var.ami
  key-pair = var.key-pair
  #pass values to instance module that are exposed from vpc module
  public_subnet_id = module.myvpc.public_subnet_id
  security_group_id = module.myvpc.security_groups_id
}
