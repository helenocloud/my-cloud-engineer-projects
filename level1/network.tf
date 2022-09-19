module "vpc" {
  source = "../modules/vpc"

  env_code     = var.env_code
  vpc_cidr     = var.vpc_cidr
}
