data "hcp_organization" "current" {}

data "hcp_project" "current" {}

resource "hcp_vault_secrets_app" "minecraft" {
  app_name    = var.waypoint_application
  description = "Secrets for Waypoint application ${var.waypoint_application}"
}

resource "random_password" "minecraft" {
  length  = 20
  lower   = true
  upper   = true
  numeric = true
  special = false
}

resource "hcp_vault_secrets_secret" "minecraft_password" {
  app_name     = hcp_vault_secrets_app.minecraft.app_name
  secret_name  = "minecraft_password"
  secret_value = random_password.minecraft.result
}

resource "hcp_vault_secrets_secret" "minecraft_server" {
  app_name     = hcp_vault_secrets_app.minecraft.app_name
  secret_name  = "minecraft_server"
  secret_value = aws_route53_record.server.name
}
