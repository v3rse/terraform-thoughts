# input variable
variable "region" {
  # default value makes it optionsl
  default = "us-east-1"
}

# converts api calls to different cloud providers
# there can be many of this
provider "aws" {
  # aws config profile name from config file (no hard coded creds)
  profile = "default"
  # using the variable here
  region = var.region
}

# S3
# instance depends on this
resource "aws_s3_bucket" "example_s3" {
  bucket = "terraform-getting-started-guide-nanaadane"
  acl    = "private"
}


# EC2
# this can be physical eg. EC2 instance or logical eg. Heroku app
# "aws_instance" - type of the resource (uses aws provider)
# "example" - resource name
resource "aws_instance" "example" {
  # specify the image for the EC2 instance
  ami = "ami-b374d5a5"
  # EC2 instance type
  instance_type = "t2.micro"
  # allows for scripting locally or remotely after the resource is created
  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
  }

  # explicit dependency
  depends_on = [aws_s3_bucket.example_s3]
}

# non-dependent resources
# it doesn't depend on any other
# it would be created in parallel
resource "aws_instance" "another" {
  ami           = "ami-b374d5a5"
  instance_type = "t2.micro"
}

# EIP
resource "aws_eip" "ip" {
  vpc = true

  # implicit dependency
  # using a created resource's details in another (resource_type.name.attribute)
  # associates eip instance with ec2 to assign it an ip
  instance = aws_instance.example.id
}

# output variable
output "ip" {
  value = aws_eip.ip.public_ip
}
