locals {
  pyramid_path       = "${path.module}/repos/minecraft-pyramid"
  pyramid_files      = fileset(local.pyramid_path, "**")
  pyramid_file_paths = { for f in local.pyramid_files : f => "${local.pyramid_path}/${f}" }
}

resource "github_repository" "pyramid" {
  name        = "hug-waypoint-minecraft-pyramid"
  visibility  = "private"
  description = "Demo repository for a Minecraft pyramid (as an HCP Waypoint Add-On)"
}

resource "github_repository_file" "pyramid" {
  for_each   = local.pyramid_file_paths
  repository = github_repository.pyramid.name
  file       = each.key
  content    = file(each.value)
}

resource "tfe_registry_module" "pyramid" {
  name = "waypoint-minecraft-pyramid"

  vcs_repo {
    display_identifier = "${var.github_organization}/${github_repository.pyramid.name}"
    identifier         = "${var.github_organization}/${github_repository.pyramid.name}"
    oauth_token_id     = tfe_oauth_client.github.oauth_token_id
    branch             = "main"
  }

  initial_version = "1.0.0"

  depends_on = [
    github_repository_file.pyramid,
  ]

  lifecycle {
    ignore_changes = [
      name,
    ]
  }
}

resource "tfe_no_code_module" "pyramid" {
  registry_module = tfe_registry_module.pyramid.id
  version_pin     = "1.0.0"

  variable_options {
    name = "material"
    type = "string"
    options = [
      "gold_block",
      "stone",
      "obsidian"
    ]
  }
}

resource "hcp_waypoint_add_on_definition" "pyramid" {
  name                            = "minecraft-pyramid"
  summary                         = "Create a Minecraft pyramid"
  description                     = "Create a Minecraft pyramid at a location (x,y,z) in an existing Minecraft world."
  terraform_project_id            = tfe_project.hug.id
  labels                          = ["minecraft", "aws"]
  terraform_no_code_module_source = "${tfe_registry_module.pyramid.registry_name}/${var.tfe_organization}/${tfe_registry_module.pyramid.name}/${tfe_registry_module.pyramid.module_provider}"
  terraform_no_code_module_id     = tfe_no_code_module.pyramid.id

  variable_options = [
    {
      name          = "origin"
      user_editable = true
      variable_type = "string"
      options       = []
    },
    {
      name          = "width"
      user_editable = true
      variable_type = "number"
      options       = []
    },
    {
      name          = "material"
      user_editable = true
      variable_type = "string"
      options = [
        "gold_block",
        "stone",
        "obsidian"
      ]
    }
  ]

  depends_on = [
    hcp_waypoint_tfc_config.default,
  ]
}
