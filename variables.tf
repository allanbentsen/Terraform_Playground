variable "ec2_instance_type" {
    description = "AWS EC2 instance type"
    type        = string
    default     = "t2.micro"
}

# Public 
variable "vpc_cidr" {
    description = "Value of cidr range for the VPC"
    type        = string
    default     = "10.0.0.0/16"
}

variable "vpc_name" {
    description = "Value of the name for the VPC"
    type        = string
    default     = "MyTestVPC"
}

variable "subnet_cidr" {
    description = "Value of subnet cidr range for the VPC"
    type        = string
    default     = "10.0.1.0/24"
}

variable "subnet_name" {
    description = "Value of the subnet name for the VPC"
    type        = string
    default     = "MyTestSubnet"
}

variable "igw_name" {
    description = "Value of the Internet Gateway name for the VPC"
    type        = string
    default     = "MyTestIGW"
}

variable "ec2_ami" {
    description = "Value of the AMI id for the EC2 instance"
    type        = string
    default     = "ami-0ddc798b3f1a5117e"
}

variable "ec2_name" {
    description = "Value of the Name for the EC2 instance"
    type        = string
    default     = "MyTestEC2"
}