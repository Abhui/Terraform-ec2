provider "aws" {
  region = "${var.aws_region}"
}

# Creating a VPC
resource "aws_vpc" "demo_vpc" {
  cidr_block = "192.168.0.0/16"
  
  tags = {
      Name = "demovpc"
      Project = "demo"
    }
}

# Creating Private subnets
resource "aws_subnet" "demo_private_a" {
  vpc_id = "${aws_vpc.demo_vpc.id}"
  availability_zone = "us-east-2a"
  cidr_block = "192.168.3.0/24"
  
  tags = {
      Name = "demo_private_a"
	  Project = "demo"
  }
}

resource "aws_subnet" "demo_private_b" {
  vpc_id = "${aws_vpc.demo_vpc.id}"
  availability_zone = "us-east-2b"
  cidr_block = "192.168.4.0/24"
  
  tags = {
      Name = "demo_private_b"
	  Project = "demo"
  }
}

#Creating Security group
resource "aws_security_group" "demo_sg" {
  name = "demo_sg"
  vpc_id = "${aws_vpc.demo_vpc.id}"
  
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "ssh"
    cidr_blocks      = [aws_vpc.demo_vpc.cidr_block]
  }

  tags{
      Name = "demosg"
      Project = "demo"
  }

#creating keypair
resource "aws_key_pair" "key-pairs" {
  key_name   = "${var.key_name}"
  public_key = file("~/.ssh/authorized_keys")
}

#ec2 instance1
resource "aws_instance" "demo1" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  subnet_id = "[aws_aws_subnet_demo_private_a.id]"
  vpc_security_group_ids = "[aws_security_group_demo_sg.id]"
  key_name = "${aws_key_pair.key-pairs.id}"
  
  tags = {
    Name = "instance1"
  }
}

#ec2 instance2
resource "aws_instance" "demo2" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  subnet_id = "[aws_aws_subnet_demo_private_b.id]"
  vpc_security_group_ids = "[aws_security_group_demo_sg.id]"
  key_name = "${aws_key_pair.key-pairs.id}"
  
  tags = {
    Name = "instance2"
  }
}