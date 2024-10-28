# vpc
resource "aws_vpc" "a8_vpc" {
    cidr_block = var.vpc_cidr

    tags = {
        Name = "fariha-a8-vpc"
    }
}

# subnet
resource "aws_subnet" "a8_subnet" {
    vpc_id = aws_vpc.a8_vpc.id
    cidr_block = var.subnet_cidr
    availability_zone = var.az

    tags = {
        Name = "fariha-a8-subnet"
    }
}

# Define AMI for instance
data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]
}

# ec2 config
resource "aws_instance" "a8_ec2" {
    ami = data.aws_ami.amazon-linux.id
    instance_type = var.ec2_type
    subnet_id = aws_subnet.a8_subnet.id

    tags = {
        Name = "fariha-a8-ec2"
    }
}
