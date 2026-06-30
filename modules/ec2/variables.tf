variable "region" {
  default = "eu-south-1"
}

variable "zone" {
  default = "eu-south-1a"
}

variable "ami" {
  type = string

}

variable "instance_name" {
  type = string
}

variable "instance_type" {
  type = string
  default = "t3.micro"
}

variable "os_size_gb" {
  type = string
  default = "20"
}

variable "env" {
  type = string
}

variable "ssh_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}