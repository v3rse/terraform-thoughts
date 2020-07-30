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
  ami = "ami-2757f631"
  # EC2 instance type
  instance_type = "t2.micro"
}
