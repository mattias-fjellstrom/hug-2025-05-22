module "hashicorp" {
  count = var.logo == "hashicorp" ? 1 : 0

  source      = "./modules/logo"
  origin      = var.origin
  coordinates = csvdecode(file("${path.module}/data/hashicorp30x30.csv"))
  material    = "obsidian"
}

module "terraform" {
  count = var.logo == "terraform" ? 1 : 0

  source      = "./modules/logo"
  origin      = var.origin
  coordinates = csvdecode(file("${path.module}/data/terraform30x30.csv"))
  material    = "purple_concrete"
}

module "boundary" {
  count = var.logo == "boundary" ? 1 : 0

  source      = "./modules/logo"
  origin      = var.origin
  coordinates = csvdecode(file("${path.module}/data/boundary30x30.csv"))
  material    = "red_concrete"
}

module "vault" {
  count = var.logo == "vault" ? 1 : 0

  source      = "./modules/logo"
  origin      = var.origin
  coordinates = csvdecode(file("${path.module}/data/vault30x30.csv"))
  material    = "yellow_concrete"
}

module "nomad" {
  count = var.logo == "nomad" ? 1 : 0

  source      = "./modules/logo"
  origin      = var.origin
  coordinates = csvdecode(file("${path.module}/data/nomad30x30.csv"))
  material    = "emerald_block"
}

module "packer" {
  count = var.logo == "packer" ? 1 : 0

  source      = "./modules/logo"
  origin      = var.origin
  coordinates = csvdecode(file("${path.module}/data/packer30x30.csv"))
  material    = "light_blue_wool"
}

module "waypoint" {
  count = var.logo == "waypoint" ? 1 : 0

  source      = "./modules/logo"
  origin      = var.origin
  coordinates = csvdecode(file("${path.module}/data/waypoint30x30.csv"))
  material    = "oxidized_copper"
}

module "consul" {
  count = var.logo == "consul" ? 1 : 0

  source      = "./modules/logo"
  origin      = var.origin
  coordinates = csvdecode(file("${path.module}/data/consul30x30.csv"))
  material    = "pink_concrete"
}

module "vagrant" {
  count = var.logo == "vagrant" ? 1 : 0

  source      = "./modules/logo"
  origin      = var.origin
  coordinates = csvdecode(file("${path.module}/data/vagrant30x30.csv"))
  material    = "blue_concrete"
}
