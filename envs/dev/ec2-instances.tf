module "tf-ec2-instance1" {
  source = "../../modules/ec2"
  instance_name = "tf-ec2-instance1"
  instance_type = "t3.small"
  env = "dev"
  ami = "amazon-linux"
  zone = "eu-south-1a"
  os_size_gb = "10"
}