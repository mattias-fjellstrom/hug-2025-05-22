locals {
  bridge_path       = "${path.module}/repos/minecraft-bridge"
  bridge_files      = fileset(local.bridge_path, "**")
  bridge_file_paths = { for f in local.bridge_files : f => "${local.bridge_path}/${f}" }
}

resource "github_repository" "bridge" {
  name        = "hug-waypoint-minecraft-bridge"
  visibility  = "private"
  description = "Demo repository for a Minecraft bridge (as an HCP Waypoint Add-On)"
}

resource "github_repository_file" "bridge" {
  for_each   = local.bridge_file_paths
  repository = github_repository.bridge.name
  file       = each.key
  content    = file(each.value)
}

resource "tfe_registry_module" "bridge" {
  name = "waypoint-minecraft-bridge"

  vcs_repo {
    display_identifier = "${var.github_organization}/${github_repository.bridge.name}"
    identifier         = "${var.github_organization}/${github_repository.bridge.name}"
    oauth_token_id     = tfe_oauth_client.github.oauth_token_id
    branch             = "main"
  }

  initial_version = "1.0.0"

  depends_on = [
    github_repository_file.bridge,
  ]

  lifecycle {
    ignore_changes = [
      name,
    ]
  }
}

resource "tfe_no_code_module" "bridge" {
  registry_module = tfe_registry_module.bridge.id
  version_pin     = "1.0.0"
}

resource "hcp_waypoint_add_on_definition" "bridge" {
  name                            = "minecraft-bridge"
  summary                         = "Create a Minecraft bridge"
  description                     = "Create a Minecraft bridge at a location (x,y,z) in an existing Minecraft world."
  terraform_project_id            = tfe_project.hug.id
  labels                          = ["minecraft", "aws"]
  terraform_no_code_module_source = "${tfe_registry_module.bridge.registry_name}/${var.tfe_organization}/${tfe_registry_module.bridge.name}/${tfe_registry_module.bridge.module_provider}"
  terraform_no_code_module_id     = tfe_no_code_module.bridge.id

  variable_options = [
    {
      name          = "start"
      user_editable = true
      variable_type = "string"
      options       = []
    },
    {
      name          = "end"
      user_editable = true
      variable_type = "string"
      options       = []
    }
  ]

  depends_on = [
    hcp_waypoint_tfc_config.default,
  ]
}
