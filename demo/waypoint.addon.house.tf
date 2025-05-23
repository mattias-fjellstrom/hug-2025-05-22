locals {
  house_path       = "${path.module}/repos/minecraft-house"
  house_files      = fileset(local.house_path, "**")
  house_file_paths = { for f in local.house_files : f => "${local.house_path}/${f}" }
}

resource "github_repository" "house" {
  name        = "hug-waypoint-minecraft-house"
  visibility  = "private"
  description = "Demo repository for a Minecraft house (as an HCP Waypoint Add-On)"
}

resource "github_repository_file" "house" {
  for_each   = local.house_file_paths
  repository = github_repository.house.name
  file       = each.key
  content    = file(each.value)
}

resource "tfe_registry_module" "house" {
  name = "waypoint-minecraft-house"

  vcs_repo {
    display_identifier = "${var.github_organization}/${github_repository.house.name}"
    identifier         = "${var.github_organization}/${github_repository.house.name}"
    oauth_token_id     = tfe_oauth_client.github.oauth_token_id
    branch             = "main"
  }

  initial_version = "1.0.0"

  depends_on = [
    github_repository_file.house,
  ]

  lifecycle {
    ignore_changes = [
      name,
    ]
  }
}

resource "tfe_no_code_module" "house" {
  registry_module = tfe_registry_module.house.id
  version_pin     = "1.0.0"
}

resource "hcp_waypoint_add_on_definition" "house" {
  name                            = "minecraft-house"
  summary                         = "Create a Minecraft house"
  description                     = "Create a Minecraft house at a location (x,y,z) in an existing Minecraft world."
  terraform_project_id            = tfe_project.hug.id
  labels                          = ["minecraft", "aws"]
  terraform_no_code_module_source = "${tfe_registry_module.house.registry_name}/${var.tfe_organization}/${tfe_registry_module.house.name}/${tfe_registry_module.house.module_provider}"
  terraform_no_code_module_id     = tfe_no_code_module.house.id

  variable_options = [
    {
      name          = "origin"
      user_editable = true
      variable_type = "string"
      options       = []
    }
  ]

  depends_on = [
    hcp_waypoint_tfc_config.default,
  ]
}
