locals {
  subnet_map = {
    "${var.region}a" = data.aws_subnet.eu_south_1a_subnet.id
    "${var.region}b" = data.aws_subnet.eu_south_1b_subnet.id
    "${var.region}c" = data.aws_subnet.eu_south_1c_subnet.id
  }
  ami_id = var.ami == "amazon-linux" ? "ami-00dee3e3d54d2189c" : var.ami == "ubuntu" ? "ami-0bb2baa8dc6c0689c" : var.ami == "rocky-linux" ? "ami-084dcba306d924b73" : var.ami
}


data "aws_vpc" "default_vpc" {
  id      = "vpc-0e98b6fc4bfebcb4d"
  region  = var.region
  default = true
}

data "aws_subnet" "eu_south_1a_subnet" {
  vpc_id = data.aws_vpc.default_vpc.id
  region = data.aws_vpc.default_vpc.region
  id = "subnet-019f83abd55f91a2d"
}

data "aws_subnet" "eu_south_1b_subnet" {
  vpc_id = data.aws_vpc.default_vpc.id
  region = data.aws_vpc.default_vpc.region
  id = "subnet-075f0fd2802cbf9f5"
}

data "aws_subnet" "eu_south_1c_subnet" {
  vpc_id = data.aws_vpc.default_vpc.id
  region = data.aws_vpc.default_vpc.region
  id = "subnet-0d2f8ffea41aa759b"
}

resource "aws_network_interface" "network_interface" {
  subnet_id = local.subnet_map[var.zone]
  ipv4_prefix_count = 1

  tags = {
    managed-by = "terraform"
    env        = var.env
  }
}

# resource "aws_network_interface_attachment" "nic_attachment" {
#   instance_id          = aws_instance.instance.id
#   network_interface_id = aws_network_interface.network_interface.id
#   device_index         = 0
# }

resource "aws_vpc_security_group_ingress_rule" "allow_tcp_ipv4" {
  security_group_id = aws_security_group.tcp.id
  from_port         = 0
  ip_protocol       = "tcp"
  to_port           = 0
  cidr_ipv4         = [var.ssh_cidr_blocks]
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.tcp.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  cidr_ipv4         = [var.ssh_cidr_blocks]
}

resource "aws_security_group" "tcp" {
  name        = "internet-access-sg"
  description = "Allow connection to ec2 instances"
  vpc_id      = data.aws_vpc.default_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    managed-by = "terraform"
    env        = var.env
  }
}

resource "aws_key_pair" "key_pair" {
  key_name   = "ssh-key-pair"
  public_key = var.public_key
}

resource "aws_instance" "instance" {
  ami                         = local.ami_id
  instance_type               = var.instance_type
  region                      = var.region
  availability_zone           = var.zone
  subnet_id                   = aws_network_interface.network_interface.subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.tcp.id]

  key_name = aws_key_pair.key_pair.key_name

  # primary_network_interface {
  #   network_interface_id = aws_network_interface.network_interface.id
  # }

  root_block_device {
    delete_on_termination = true
    encrypted = false
    volume_size = var.os_size_gb
  }


  tags = {
    Name       = var.instance_name
    managed-by = "terraform"
    env        = var.env
  }
}