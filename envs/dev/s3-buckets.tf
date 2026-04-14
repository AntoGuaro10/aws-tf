locals {
  s3_buckets = {
    for f in fileset("${path.module}/s3_buckets", "**/*.json") :
    trimsuffix(f, ".json") => jsondecode(file("${path.module}/s3_buckets/${f}"))
  }
}

module "s3-buckets" {
  source = "../../modules/s3"
  for_each = local.s3_buckets

  bucket_name = each.value.bucket_name
  region = each.value.region
  env = each.value.env
  versioning = each.value.versioning
}