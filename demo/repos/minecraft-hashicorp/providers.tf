terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.104.0"
    }

    minecraft = {
      source  = "HashiCraft/minecraft"
      version = "0.1.1"
    }
  }
}

provider "minecraft" {
  address  = "${data.hcp_vault_secrets_secret.minecraft_server.secret_value}:25575"
  password = data.hcp_vault_secrets_secret.minecraft_password.secret_value
}
