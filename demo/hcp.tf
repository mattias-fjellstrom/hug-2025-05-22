resource "hcp_waypoint_tfc_config" "default" {
  tfc_org_name = var.tfe_organization
  token        = tfe_team_token.hug.token
}
