locals {
  ec2s = {
    for f in fileset("${path.module}/ec2_list", "**/*.json") :
    trimsuffix(f, ".json") => jsondecode(file("${path.module}/ec2_list/${f}"))
  }
}

module "tf-ec2-instance" {
  source = "../../modules/ec2"
  for_each = local.ec2s
  instance_name = each.value.instance_name
  instance_type = each.value.instance_type
  env = each.value.env
  ami = each.value.ami
  zone = each.value.zone
  os_size_gb = each.value.os_size_gb
}