terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-remote-state-abc8805"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-remote-state"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}
