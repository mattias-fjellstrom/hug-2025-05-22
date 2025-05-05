terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.97.0"
    }

    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.104.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.5.2"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
