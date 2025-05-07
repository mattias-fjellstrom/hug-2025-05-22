data "hcp_vault_secrets_secret" "minecraft_password" {
  app_name    = var.waypoint_application
  secret_name = "minecraft_password"
}

data "hcp_vault_secrets_secret" "minecraft_server" {
  app_name    = var.waypoint_application
  secret_name = "minecraft_server"
}
