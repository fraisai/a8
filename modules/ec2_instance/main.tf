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

# Create & attach IGW to VPC
resource "aws_internet_gateway" "a8_igw" {
  vpc_id = aws_vpc.a8_vpc.id # attach igw to vpc
  tags = {
    Name = "fariha-igw-a8"
  }
}

# Create Route table (public subnets)
resource "aws_route_table" "a8_rt" {
  vpc_id = aws_vpc.a8_vpc.id
  
  # to give access to the internet, add destination of 0.0.0.0/0 and target the igw I created earlier
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.a8_igw.id
  }
}

# Associate my subnet with the route table 
resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.a8_rt.id
  subnet_id = aws_subnet.a8_subnet.id
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
