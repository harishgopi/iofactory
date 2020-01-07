variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_path" {}
variable "aws_key_name" {}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-east-2a"
}

variable "amis" {
    description = "AMIs by region"
    default = {
        us-east-2a = "ami-f1810f86" # ubuntu 14.04 LTS
    }
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "subnet_cidrs_public" {
    description = "CIDRs for the public Subnets"
    default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    type = "list"
}

variable "subnet_cidrs_private" {
    description = "CIDR for the Private Subnets"
    default = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
    type = "list"
}

