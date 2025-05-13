# terraform {
#   backend "s3" {
#     bucket = "bucketforb92025"
#     region = "us-east-1"
#     key = "terraform.tfstate"
#   }
# }



resource "aws_instance" "ec2Instance" {
    ami = var.ami
    instance_type = var.instanceType
    key_name = var.key-pair
    subnet_id = aws_subnet.pub_subnet.id
    security_groups = [aws_security_group.newSecuritygrp.id]
    # vpc_security_group_ids = [aws_security_group.newSecuritygrp.id]
    tags = {
      name = "window-instance"
    }
}
