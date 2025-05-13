variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "pvt_cidr" {
    default = "10.0.0.0/20"
}

variable "pub_cidr" {
    default = "10.0.16.0/20"
}

variable "instanceType" {
    default = "t2.micro"
}

variable "ami" {
    default = "ami-0f9de6e2d2f067fca"
}

variable "key-pair" {
    default = "terra-key"
}

variable "key_location" {
    default = "C:/Users/vaish/Downloads/terra-key.pem"
}
