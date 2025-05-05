terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.94.1"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3.7"
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
  region = "eu-west-1"

  default_tags {
    tags = {
      Name = "waypoint-${var.waypoint_application}"
    }
  }
}
