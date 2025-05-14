output "aws_instance_public_IP" {
    value = aws_instance.ubuntu.public_ip
}
output "aws_instance_url" {
    value = "http://${aws_instance.ubuntu.public_dns}"
}
