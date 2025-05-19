terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.94.1"
    }

    github = {
      source  = "integrations/github"
      version = "~> 6.6.0"
    }

    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.104.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.5.3"
    }

    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.64.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.1.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "github" {
  owner = var.github_organization
}

provider "tfe" {
  organization = var.tfe_organization
}

provider "hcp" {
  project_id = var.hcp_project
}
