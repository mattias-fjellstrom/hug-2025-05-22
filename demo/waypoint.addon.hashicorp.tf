locals {
  hashicorp_path       = "${path.module}/repos/minecraft-hashicorp"
  hashicorp_files      = fileset(local.hashicorp_path, "**")
  hashicorp_file_paths = { for f in local.hashicorp_files : f => "${local.hashicorp_path}/${f}" }
}

resource "github_repository" "hashicorp" {
  name        = "hug-waypoint-minecraft-hashicorp"
  visibility  = "private"
  description = "Demo repository for building HashiCorp logos in Minecraft (as an HCP Waypoint Add-On)"
}

resource "github_repository_file" "hashicorp" {
  for_each   = local.hashicorp_file_paths
  repository = github_repository.hashicorp.name
  file       = each.key
  content    = file(each.value)
}

resource "tfe_registry_module" "hashicorp" {
  name = "waypoint-minecraft-hashicorp"

  vcs_repo {
    display_identifier = "${var.github_organization}/${github_repository.hashicorp.name}"
    identifier         = "${var.github_organization}/${github_repository.hashicorp.name}"
    oauth_token_id     = tfe_oauth_client.github.oauth_token_id
    branch             = "main"
  }

  initial_version = "1.0.0"

  depends_on = [
    github_repository_file.hashicorp,
  ]

  lifecycle {
    ignore_changes = [
      name,
    ]
  }
}

resource "tfe_no_code_module" "hashicorp" {
  registry_module = tfe_registry_module.hashicorp.id
  version_pin     = "1.0.0"

  variable_options {
    name = "logo"
    type = "string"
    options = [
      "hashicorp",
      "terraform",
      "vault",
      "boundary",
      "waypoint",
      "packer",
      "consul",
      "nomad",
      "vagrant",
    ]
  }
}

resource "hcp_waypoint_add_on_definition" "hashicorp" {
  name                            = "minecraft-hashicorp"
  summary                         = "Create a HashiCorp product logo in Minecraft"
  description                     = "Create a HashiCorp logo at a location (x,y,z) in an existing Minecraft world."
  terraform_project_id            = tfe_project.hug.id
  labels                          = ["minecraft", "aws"]
  terraform_no_code_module_source = "${tfe_registry_module.hashicorp.registry_name}/${var.tfe_organization}/${tfe_registry_module.hashicorp.name}/${tfe_registry_module.hashicorp.module_provider}"
  terraform_no_code_module_id     = tfe_no_code_module.hashicorp.id

  variable_options = [
    {
      name          = "origin"
      user_editable = true
      variable_type = "string"
      options       = []
    },
    {
      name          = "logo"
      user_editable = true
      variable_type = "string"
      options = [
        "hashicorp",
        "terraform",
        "vault",
        "boundary",
        "waypoint",
        "packer",
        "consul",
        "nomad",
        "vagrant",
      ]
    }
  ]

  depends_on = [
    hcp_waypoint_tfc_config.default,
  ]
}
