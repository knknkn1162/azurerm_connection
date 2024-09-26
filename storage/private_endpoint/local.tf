module "random_string" {
  source = "../../lib/random_string"
  length = 12
}

locals {
  storage_prefix = module.random_string.res
}