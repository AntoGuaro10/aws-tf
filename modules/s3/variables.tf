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

variable "regional_s3_bucket_namespace" {
  type = bool
  default = false
}