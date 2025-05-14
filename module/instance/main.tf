resource "aws_instance" "ubuntu" {
    ami = var.ami
    instance_type = var.instanceType
    key_name = var.key-pair
    security_groups = [var.security_group_id]
    subnet_id = var.public_subnet_id

    user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo systemctl enable apache2

              echo "<h1>Hello from Terraform</h1>" | sudo tee /var/www/html/index.html
            EOF

    tags = {
      name = "Ubuntu Instance"
    }
}
