resource "tfe_project" "hug" {
  name        = "hug"
  description = "Project for HUG demo resources"
}

resource "tfe_team" "hug" {
  name = "hug"
}

resource "tfe_team_project_access" "hug" {
  project_id = tfe_project.hug.id
  team_id    = tfe_team.hug.id
  access     = "maintain"
}

resource "tfe_team_token" "hug" {
  team_id = tfe_team.hug.id
}

resource "tfe_oauth_client" "github" {
  name                = "GitHub Organization (${var.github_organization})"
  api_url             = "https://api.github.com"
  http_url            = "https://github.com"
  oauth_token         = var.github_token
  service_provider    = "github"
  organization_scoped = true
}
