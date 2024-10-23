#provider Block
provider "aws" {
    profile = "playground"
    region  = "us-east-1"
}

# VPC
resource "aws_vpc" "my_test_vpc" {
    cidr_block = var.vpc_cidr

    tags = {
        Name = var.vpc_name
    }  
}

# Subnet
resource "aws_subnet" "my_test_subnet" {
    vpc_id     = aws_vpc.my_test_vpc.id
    cidr_block = var.subnet_cidr

    tags = {
        Name = var.subnet_name
    }  
}


# Internet Gateway
resource "aws_internet_gateway" "my_ig" {
    vpc_id     = aws_vpc.my_test_vpc.id

    tags = {
        Name = var.igw_name
    }  
}

# Route Table
resource "aws_route_table" "public_rt" {
    vpc_id     = aws_vpc.my_test_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_ig.id
    }

    tags = {
        Name = var.igw_name
    }  
}

# Route Table Associations
resource "aws_route_table_association" "my_route_table_association" {
    subnet_id      = aws_subnet.my_test_subnet.id
    route_table_id = aws_route_table.public_rt.id
}


# Security Group (open for HTTP)
resource "aws_security_group" "app_sg" {
    name = "MySSG"
    vpc_id = aws_vpc.my_test_vpc.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }  

    tags = {
        Name = "MySSG"
        Purpose = "HTTP and SSH access"
    }

    lifecycle {      
      create_before_destroy = true
    }

    timeouts {
      delete = "5m"
    }
}

# EC2 Instance

resource "aws_instance" "app_server" {
    ami           = var.ec2_ami
    instance_type = var.ec2_instance_type

    subnet_id                   = aws_subnet.my_test_subnet.id
    vpc_security_group_ids      = [aws_security_group.app_sg.id]
    associate_public_ip_address = true

    user_data = <<-EOF
    #!/bin/bash -ex

    amazon-linux-extras install nginx1 -y
    echo "<h1>This is my new server</h1>" > /usr/share/nginx/html/index.html
    systemctl enable nginx
    systemctl start nginx
    EOF

    tags = {
        Name = var.ec2_name
    }  
}