# converts api calls to different cloud providers
# there can be many of this
provider "aws" {
  # aws config profile name from config file (no hard coded creds)
  profile = "default"
  region  = "us-east-1"
}

# this can be physical eg. EC2 instance or logical eg. Heroku app
# "aws_instance" - type of the resource (uses aws provider)
# "example" - resource name
resource "aws_instance" "example" {
  # specify the image for the EC2 instance
  ami = "ami-b374d5a5"
  # EC2 instance type
  instance_type = "t2.micro"
}

resource "aws_eip" "ip" {
  vpc = true
  # using a created resource's details in another (resource_type.name.attribute)
  # associates eip instance with ec2 to assign it an ip
  instance = aws_instance.example.id
}
