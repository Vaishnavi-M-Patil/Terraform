data "aws_security_group" "secGroup" {
  name = var.security_group
  vpc_id = var.vpc_id
}

data "aws_key_pair" "keyName" {
    key_name = "terra-key"
}

resource "aws_instance" "ec2Instance" {
    ami = var.ami
    instance_type = var.instanceType
    
 # Terraform's aws_instance block requires the key pair name, not its ID. 
 #Also you reference its name directly in your Terraform code. i.e.  key_name = "terra-key"
    key_name = data.aws_key_pair.keyName.key_name                  
    security_groups = [data.aws_security_group.secGroup.name]
    tags = {
      name = "window-instance"
    }
}
