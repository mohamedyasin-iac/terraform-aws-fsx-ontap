provider "aws" {
  profile = "itx-035"
  region = "eu-west-1"

  ignore_tags {
    keys         = ["appbranch", "Hostname", "bca", "disableTermination", "dmz", "gxp", "legal_hold", "region", "serverrole", "sox", "app_environment", "bitbucketproject", "cookbook", "functional", "oracle_serversize", "role"]
    key_prefixes = ["vpcx-"]
  }
}

terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}
