variable "ec2_type" {
    type = string
    description = "Instance Type"
    default = "t4g.nano"
}

variable "az" {
    type = string
    default = "us-west-2a"
}

variable "vpc_cidr" {
    type = string
    default = "172.16.0.0/16"
}

variable "subnet_cidr" {
    type = string
    default = "172.16.0.0/18"
}