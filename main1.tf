# Terraform Cluster Tutorial

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}
resource "aws_instance" "example" {
  # AMI ID for Amazon Linux AMI 2016.03.0 (HVM)
  ami           = "ami-cd0f5cb6"
  instance_type = "t2.micro"

  tags {
    Name = "Tamerity"
  }
}
resource "aws_s3_bucket" "terraform" {
  bucket = "my_tf_state_bucket"
  acl    = "private"
  
  versioning {
    enabled = true
  }
  lifecycle {
prevent_destroy = false
}
  tags {
    Name        = "Terraform"
    Environment = "Dev"
  }
}

# Create a VPC to launch our instances into
resource "aws_vpc" "default" {
  cidr_block = "11.0.0.0/16"
  tags {
  Name = "Tamerity"
  }
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

# Create a subnet for the ELB & EC2 intances
resource "aws_subnet" "default" {
  vpc_id                  = "${aws_vpc.default.id}"
  availability_zone       = "us-east-1c"
  cidr_block              = "11.0.1.0/24"
  map_public_ip_on_launch = true

  tags {
        Name = "Subnet A"
  }
}