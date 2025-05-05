locals {
  server_path       = "${path.module}/repos/minecraft-server"
  server_files      = fileset(local.server_path, "**")
  server_file_paths = { for f in local.server_files : f => "${local.server_path}/${f}" }
}

resource "github_repository" "server" {
  name        = "hug-waypoint-minecraft-server"
  visibility  = "private"
  description = "Demo repository for a Minecraft server on AWS (for HCP Waypoint)"
}

resource "github_repository_file" "server" {
  for_each = local.server_file_paths

  repository = github_repository.server.name
  file       = each.key
  content    = file(each.value)
}

resource "tfe_registry_module" "server" {
  name = "waypoint-minecraft-server"

  vcs_repo {
    display_identifier = "${var.github_organization}/${github_repository.server.name}"
    identifier         = "${var.github_organization}/${github_repository.server.name}"
    oauth_token_id     = tfe_oauth_client.github.oauth_token_id
    branch             = "main"
  }

  initial_version = "1.0.0"

  depends_on = [
    github_repository_file.server,
  ]

  lifecycle {
    ignore_changes = [
      name,
    ]
  }
}

data "aws_route53_zones" "all" {}

data "aws_route53_zone" "all" {
  for_each = toset(data.aws_route53_zones.all.ids)
  zone_id  = each.value
}

locals {
  hosted_zone_names = [for zone in data.aws_route53_zone.all : zone.name]
}

resource "tfe_no_code_module" "server" {
  registry_module = tfe_registry_module.server.id

  version_pin = "1.0.0"

  variable_options {
    name    = "domain"
    type    = "string"
    options = local.hosted_zone_names
  }
}

resource "hcp_waypoint_template" "server" {
  name        = "minecraft-server"
  summary     = "A Minecraft server running on AWS EC2"
  description = "A self-service provisioned Minecraft server on AWS EC2. Uses an AMI from Packer. Runs in a dedicated VPC."


  terraform_project_id            = tfe_project.hug.id
  labels                          = ["minecraft", "aws"]
  terraform_no_code_module_source = "private/${var.tfe_organization}/minecraft-server/waypoint"
  terraform_no_code_module_id     = tfe_no_code_module.server.id

  use_module_readme = true

  variable_options = [
    {
      name          = "domain"
      variable_type = "string"
      user_editable = true
      options       = local.hosted_zone_names
    }
  ]

  depends_on = [
    tfe_no_code_module.server,
    hcp_waypoint_tfc_config.default,
  ]
}
