locals {
  origin = {
    x = tonumber(split(",", var.origin)[0])
    y = tonumber(split(",", var.origin)[1])
    z = tonumber(split(",", var.origin)[2])
  }

  hashicorp_coordinates = csvdecode(file("${path.module}/data/hashicorp${var.size}.csv"))
  hashicorp = [
    for c in local.hashicorp_coordinates : "${local.origin.x + tonumber(c.x)},${local.origin.y + tonumber(c.y)},${local.origin.z + tonumber(c.z)}"
  ]

  terraform_coordinates = csvdecode(file("${path.module}/data/terraform${var.size}.csv"))
  terraform = [
    for c in local.terraform_coordinates : "${local.origin.x + tonumber(c.x)},${local.origin.y + tonumber(c.y)},${local.origin.z + tonumber(c.z) - 10}"
  ]

  boundary_coordinates = csvdecode(file("${path.module}/data/boundary${var.size}.csv"))
  boundary = [
    for c in local.boundary_coordinates : "${local.origin.x + tonumber(c.x)},${local.origin.y + tonumber(c.y)},${local.origin.z + tonumber(c.z) - 20}"
  ]

  vault_coordinates = csvdecode(file("${path.module}/data/vault${var.size}.csv"))
  vault = [
    for c in local.vault_coordinates : "${local.origin.x + tonumber(c.x)},${local.origin.y + tonumber(c.y)},${local.origin.z + tonumber(c.z) - 30}"
  ]

  nomad_coordinates = csvdecode(file("${path.module}/data/nomad${var.size}.csv"))
  nomad = [
    for c in local.nomad_coordinates : "${local.origin.x + tonumber(c.x)},${local.origin.y + tonumber(c.y)},${local.origin.z + tonumber(c.z) - 40}"
  ]

  packer_coordinates = csvdecode(file("${path.module}/data/packer${var.size}.csv"))
  packer = [
    for c in local.packer_coordinates : "${local.origin.x + tonumber(c.x)},${local.origin.y + tonumber(c.y)},${local.origin.z + tonumber(c.z) - 50}"
  ]

  waypoint_coordinates = csvdecode(file("${path.module}/data/waypoint${var.size}.csv"))
  waypoint = [
    for c in local.waypoint_coordinates : "${local.origin.x + tonumber(c.x)},${local.origin.y + tonumber(c.y)},${local.origin.z + tonumber(c.z) - 60}"
  ]

  consul_coordinates = csvdecode(file("${path.module}/data/consul${var.size}.csv"))
  consul = [
    for c in local.consul_coordinates : "${local.origin.x + tonumber(c.x)},${local.origin.y + tonumber(c.y)},${local.origin.z + tonumber(c.z) - 70}"
  ]

  vagrant_coordinates = csvdecode(file("${path.module}/data/vagrant${var.size}.csv"))
  vagrant = [
    for c in local.vagrant_coordinates : "${local.origin.x + tonumber(c.x)},${local.origin.y + tonumber(c.y)},${local.origin.z + tonumber(c.z) - 80}"
  ]
}

resource "minecraft_block" "hashicorp" {
  for_each = toset(local.hashicorp)
  material = "minecraft:obsidian"
  position = {
    x = tonumber(split(",", each.value)[0])
    y = tonumber(split(",", each.value)[1])
    z = tonumber(split(",", each.value)[2])
  }
}

resource "minecraft_block" "terraform" {
  for_each = toset(local.terraform)
  material = "minecraft:purple_concrete"
  position = {
    x = tonumber(split(",", each.value)[0])
    y = tonumber(split(",", each.value)[1])
    z = tonumber(split(",", each.value)[2])
  }

  depends_on = [minecraft_block.hashicorp]
}

resource "minecraft_block" "boundary" {
  for_each = toset(local.boundary)
  material = "minecraft:red_concrete"
  position = {
    x = tonumber(split(",", each.value)[0])
    y = tonumber(split(",", each.value)[1])
    z = tonumber(split(",", each.value)[2])
  }

  depends_on = [minecraft_block.terraform]
}

resource "minecraft_block" "vault" {
  for_each = toset(local.vault)
  material = "minecraft:yellow_concrete"
  position = {
    x = tonumber(split(",", each.value)[0])
    y = tonumber(split(",", each.value)[1])
    z = tonumber(split(",", each.value)[2])
  }

  depends_on = [minecraft_block.boundary]
}

resource "minecraft_block" "nomad" {
  for_each = toset(local.nomad)
  material = "minecraft:emerald_block"
  position = {
    x = tonumber(split(",", each.value)[0])
    y = tonumber(split(",", each.value)[1])
    z = tonumber(split(",", each.value)[2])
  }

  depends_on = [minecraft_block.vault]
}

resource "minecraft_block" "packer" {
  for_each = toset(local.packer)
  material = "minecraft:light_blue_wool"
  position = {
    x = tonumber(split(",", each.value)[0])
    y = tonumber(split(",", each.value)[1])
    z = tonumber(split(",", each.value)[2])
  }

  depends_on = [minecraft_block.nomad]
}

resource "minecraft_block" "waypoint" {
  for_each = toset(local.waypoint)
  material = "minecraft:oxidized_copper"
  position = {
    x = tonumber(split(",", each.value)[0])
    y = tonumber(split(",", each.value)[1])
    z = tonumber(split(",", each.value)[2])
  }

  depends_on = [minecraft_block.packer]
}

resource "minecraft_block" "consul" {
  for_each = toset(local.consul)
  material = "minecraft:pink_concrete"
  position = {
    x = tonumber(split(",", each.value)[0])
    y = tonumber(split(",", each.value)[1])
    z = tonumber(split(",", each.value)[2])
  }

  depends_on = [minecraft_block.waypoint]
}

resource "minecraft_block" "vagrant" {
  for_each = toset(local.vagrant)
  material = "minecraft:blue_concrete"
  position = {
    x = tonumber(split(",", each.value)[0])
    y = tonumber(split(",", each.value)[1])
    z = tonumber(split(",", each.value)[2])
  }
}
