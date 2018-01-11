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
