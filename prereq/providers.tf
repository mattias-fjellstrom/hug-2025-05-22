terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.104.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.5.2"
    }
  }
}
