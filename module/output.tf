output "aws_instance_public_IP" {
    value = module.ec2instance.aws_instance_public_IP
}

output "vpc_id" {
    value = module.myvpc.vpc_id
}
