provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "example" {
    ami = "ami-2d39803a"
    # m3 instances are not VPC only
    instance_type = "m3.medium"
    key_name = "websites"
    tags {
        Name = "Hello, Terraform"
    }
}
