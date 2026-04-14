variable "env" {
  type = string
}

variable "region" {
  type = string
  default = "eu-south-1"
}

variable "bucket_name" {
  type = string
}

variable "versioning" {
  type = string
  default = "Disabled"
}