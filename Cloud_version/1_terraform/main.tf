terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.64.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

#1. VPC

resource "aws_vpc" "vpc_zoomcamp" {
  cidr_block       = "172.16.0.0/16"
  enable_dns_hostnames = "true"
  tags = {
    Name = "vpc_zoomcamp"
  }
}


#2. internet gateway

resource "aws_internet_gateway" "gtw_zoomcamp" {
  vpc_id = aws_vpc.vpc_zoomcamp.id

  tags = {
    Name = "gtw_zoomcamp"
  }
}

#3. custom route table

resource "aws_route_table" "route_zoomcamp" {
  vpc_id = aws_vpc.vpc_zoomcamp.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gtw_zoomcamp.id
  }

  tags = {
    Name = "route_zoomcamp"
  }
}

#4. subnets

resource "aws_subnet" "sub_zoomcamp" {
  vpc_id     = aws_vpc.vpc_zoomcamp.id
  cidr_block = "172.16.10.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "sub_zoomcamp"
  }
}

resource "aws_subnet" "sub_zoomcamp_2" {
  vpc_id     = aws_vpc.vpc_zoomcamp.id
  cidr_block = "172.16.11.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "sub_zoomcamp_2"
  }
}

resource "aws_subnet" "sub_zoomcamp_3" {
  vpc_id     = aws_vpc.vpc_zoomcamp.id
  cidr_block = "172.16.12.0/24"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "sub_zoomcamp_3"
  }
}

#5. associate subnets with route

resource "aws_route_table_association" "assoc_zoomcamp" {
  subnet_id      = aws_subnet.sub_zoomcamp.id
  route_table_id = aws_route_table.route_zoomcamp.id
}

resource "aws_route_table_association" "assoc_zoomcamp_2" {
  subnet_id      = aws_subnet.sub_zoomcamp_2.id
  route_table_id = aws_route_table.route_zoomcamp.id
}

resource "aws_route_table_association" "assoc_zoomcamp_3" {
  subnet_id      = aws_subnet.sub_zoomcamp_3.id
  route_table_id = aws_route_table.route_zoomcamp.id
}

#6. security group

resource "aws_security_group" "sec_gr_zoomcamp" {
  name        = "sec_gr_zoomcamp"
  description = "Allow WEB inbound traffic"
  vpc_id      = aws_vpc.vpc_zoomcamp.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  ingress {
    description      = "prefect"
    from_port        = 4200
    to_port          = 4200
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  ingress {
    description      = "redshift"
    from_port        = 5439
    to_port          = 5439
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  ingress {
    description      = "metabase"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_all_WEB"
  }
}


#7. network interface

resource "aws_network_interface" "net_inter_zoomcamp" {
  subnet_id       = aws_subnet.sub_zoomcamp.id
  private_ips     = ["172.16.10.100"]
  security_groups = [aws_security_group.sec_gr_zoomcamp.id]

}

#8. ec2

resource "aws_instance" "ec2_zoomcamp" {
  ami           = "${var.ec2_ami}"
  instance_type = "t2.medium"
  key_name = "${var.key_name}"
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 11
  }

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.net_inter_zoomcamp.id
  }
  
  tags = {
    Name = "ec2_zoomcamp"
  }
}


#9 - s3 bucket
resource "aws_s3_bucket" "zoomcamp_s3" {
  bucket = "${var.s3_bucket_name}"
  force_destroy = "true"
  tags = {
    Name        = "zoomcamp-s3"
    Environment = "Dev"
  }
}


#10 - redshift namespace and database
resource "aws_redshiftserverless_namespace" "zoomcamp_nmsp" {
  namespace_name = "${var.namespace_name}" 

  db_name = "${var.db_name}"
  admin_user_password = "${var.db_password}"
  admin_username = "${var.db_user}"
  
}

#11 - redshift workgroup
resource "aws_redshiftserverless_workgroup" "zoomcamp_wrgr" {
  namespace_name = "${var.namespace_name}" 
  workgroup_name = "${var.workgroup_name}"
  base_capacity = 8
  publicly_accessible = "true"
  subnet_ids = [aws_subnet.sub_zoomcamp.id, aws_subnet.sub_zoomcamp_2.id, aws_subnet.sub_zoomcamp_3.id ]
  security_group_ids = [aws_security_group.sec_gr_zoomcamp.id]
}