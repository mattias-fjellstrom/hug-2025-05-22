locals {
  # start and end coordinates, make sure z1>z2 because the calculated depend on this.
  start = {
    x = tonumber(split(",", var.start)[0])
    y = tonumber(split(",", var.start)[1])
    z = tonumber(split(",", var.start)[2]) > tonumber(split(",", var.end)[2]) ? tonumber(split(",", var.start)[2]) : tonumber(split(",", var.end)[2])
  }

  end = {
    x = tonumber(split(",", var.end)[0])
    y = tonumber(split(",", var.end)[1])
    z = tonumber(split(",", var.start)[2]) > tonumber(split(",", var.end)[2]) ? tonumber(split(",", var.end)[2]) : tonumber(split(",", var.start)[2])
  }

  # default block material
  material = "minecraft:red_concrete"

  length = abs(local.end.z - local.start.z)
  middle = local.start.z - floor(local.length / 2)

  # height of the pillars
  height = floor(local.length / 3)

  # how many blocks in the pillars start
  pillar_position = floor(local.length / 8)

  # how deep the pillars go below the bridge
  pillar_depth = 60

  # runway is the actual road
  runway = flatten([
    for z in range(local.start.z + 2 * local.height, local.end.z - 2 * local.height - 1) : [
      # main bridge road
      "${local.start.x - 3};${local.start.y + 2};${z};${local.material}",
      "${local.start.x - 2};${local.start.y + 2};${z};${local.material}",
      "${local.start.x - 1};${local.start.y + 2};${z};${local.material}",
      "${local.start.x + 0};${local.start.y + 2};${z};${local.material}",
      "${local.start.x + 1};${local.start.y + 2};${z};${local.material}",
      "${local.start.x + 2};${local.start.y + 2};${z};${local.material}",

      # supporting structure under bridge road
      "${local.start.x - 2};${local.start.y + 1};${z};${local.material}",
      "${local.start.x + 1};${local.start.y + 1};${z};${local.material}",
    ]
  ])

  # the four bridge pillars + connecting cross beams
  pillars = concat(flatten([
    for y in range(local.start.y - local.pillar_depth, local.start.y + local.height) : [
      "${local.start.x + 3};${y};${local.start.z + local.pillar_position};${local.material}",
      "${local.start.x - 4};${y};${local.start.z + local.pillar_position};${local.material}",
      "${local.end.x + 3};${y};${local.end.z - local.pillar_position};${local.material}",
      "${local.end.x - 4};${y};${local.end.z - local.pillar_position};${local.material}",
    ]
    ]), [
    "${local.start.x + 2};${local.start.y + local.height - 1};${local.start.z + local.pillar_position};${local.material}",
    "${local.start.x + 1};${local.start.y + local.height - 1};${local.start.z + local.pillar_position};${local.material}",
    "${local.start.x + 0};${local.start.y + local.height - 1};${local.start.z + local.pillar_position};${local.material}",
    "${local.start.x - 1};${local.start.y + local.height - 1};${local.start.z + local.pillar_position};${local.material}",
    "${local.start.x - 2};${local.start.y + local.height - 1};${local.start.z + local.pillar_position};${local.material}",
    "${local.start.x - 3};${local.start.y + local.height - 1};${local.start.z + local.pillar_position};${local.material}",

    "${local.start.x + 2};${local.start.y + local.height};${local.start.z + local.pillar_position};${local.material}",
    "${local.start.x + 1};${local.start.y + local.height};${local.start.z + local.pillar_position};${local.material}",
    "${local.start.x + 0};${local.start.y + local.height};${local.start.z + local.pillar_position};${local.material}",
    "${local.start.x - 1};${local.start.y + local.height};${local.start.z + local.pillar_position};${local.material}",
    "${local.start.x - 2};${local.start.y + local.height};${local.start.z + local.pillar_position};${local.material}",
    "${local.start.x - 3};${local.start.y + local.height};${local.start.z + local.pillar_position};${local.material}",

    "${local.start.x + 1};${local.start.y + local.height + 1};${local.start.z + local.pillar_position};${local.material}",
    "${local.start.x + 0};${local.start.y + local.height + 1};${local.start.z + local.pillar_position};${local.material}",
    "${local.start.x - 1};${local.start.y + local.height + 1};${local.start.z + local.pillar_position};${local.material}",
    "${local.start.x - 2};${local.start.y + local.height + 1};${local.start.z + local.pillar_position};${local.material}",

    "${local.start.x + 0};${local.start.y + local.height + 2};${local.start.z + local.pillar_position};${local.material}",
    "${local.start.x - 1};${local.start.y + local.height + 2};${local.start.z + local.pillar_position};${local.material}",


    "${local.end.x + 2};${local.end.y + local.height - 1};${local.end.z - local.pillar_position};${local.material}",
    "${local.end.x + 1};${local.end.y + local.height - 1};${local.end.z - local.pillar_position};${local.material}",
    "${local.end.x + 0};${local.end.y + local.height - 1};${local.end.z - local.pillar_position};${local.material}",
    "${local.end.x - 1};${local.end.y + local.height - 1};${local.end.z - local.pillar_position};${local.material}",
    "${local.end.x - 2};${local.end.y + local.height - 1};${local.end.z - local.pillar_position};${local.material}",
    "${local.end.x - 3};${local.end.y + local.height - 1};${local.end.z - local.pillar_position};${local.material}",

    "${local.end.x + 2};${local.end.y + local.height};${local.end.z - local.pillar_position};${local.material}",
    "${local.end.x + 1};${local.end.y + local.height};${local.end.z - local.pillar_position};${local.material}",
    "${local.end.x + 0};${local.end.y + local.height};${local.end.z - local.pillar_position};${local.material}",
    "${local.end.x - 1};${local.end.y + local.height};${local.end.z - local.pillar_position};${local.material}",
    "${local.end.x - 2};${local.end.y + local.height};${local.end.z - local.pillar_position};${local.material}",
    "${local.end.x - 3};${local.end.y + local.height};${local.end.z - local.pillar_position};${local.material}",

    "${local.end.x + 1};${local.end.y + local.height + 1};${local.end.z - local.pillar_position};${local.material}",
    "${local.end.x + 0};${local.end.y + local.height + 1};${local.end.z - local.pillar_position};${local.material}",
    "${local.end.x - 1};${local.end.y + local.height + 1};${local.end.z - local.pillar_position};${local.material}",
    "${local.end.x - 2};${local.end.y + local.height + 1};${local.end.z - local.pillar_position};${local.material}",

    "${local.end.x + 0};${local.end.y + local.height + 2};${local.end.z - local.pillar_position};${local.material}",
    "${local.end.x - 1};${local.end.y + local.height + 2};${local.end.z - local.pillar_position};${local.material}",
  ])

  # these are the suspension cables
  suspension = flatten([
    # pillar 1
    [for y in range(2, local.height - 1) : "${local.start.x + 3};${local.start.y + y};${local.start.z + local.pillar_position + local.height - y - 1};${local.material}"],
    [for y in range(2, local.height - 1) : "${local.start.x + 3};${local.start.y + y};${local.start.z + local.pillar_position - local.height + y + 1};${local.material}"],

    # pillar 2
    [for y in range(2, local.height - 1) : "${local.start.x - 4};${local.start.y + y};${local.start.z + local.pillar_position + local.height - y - 1};${local.material}"],
    [for y in range(2, local.height - 1) : "${local.start.x - 4};${local.start.y + y};${local.start.z + local.pillar_position - local.height + y + 1};${local.material}"],

    # pillar 3
    [for y in range(2, local.height - 1) : "${local.end.x + 3};${local.end.y + y};${local.end.z - local.pillar_position + local.height - y - 1};${local.material}"],
    [for y in range(2, local.height - 1) : "${local.end.x + 3};${local.end.y + y};${local.end.z - local.pillar_position - local.height + y + 1};${local.material}"],

    # pillar 4
    [for y in range(2, local.height - 1) : "${local.end.x - 4};${local.end.y + y};${local.end.z - local.pillar_position + local.height - y - 1};${local.material}"],
    [for y in range(2, local.height - 1) : "${local.end.x - 4};${local.end.y + y};${local.end.z - local.pillar_position - local.height + y + 1};${local.material}"],
  ])

  # torches placed on the suspension cables
  suspension_lanterns = flatten([
    # pillar 1
    [for y in range(2, local.height - 1) : "${local.start.x + 3};${local.start.y + y + 1};${local.start.z + local.pillar_position + local.height - y - 1};minecraft:redstone_torch"],
    [for y in range(2, local.height - 1) : "${local.start.x + 3};${local.start.y + y + 1};${local.start.z + local.pillar_position - local.height + y + 1};minecraft:redstone_torch"],

    # pillar 2
    [for y in range(2, local.height - 1) : "${local.start.x - 4};${local.start.y + y + 1};${local.start.z + local.pillar_position + local.height - y - 1};minecraft:redstone_torch"],
    [for y in range(2, local.height - 1) : "${local.start.x - 4};${local.start.y + y + 1};${local.start.z + local.pillar_position - local.height + y + 1};minecraft:redstone_torch"],

    # pillar 3
    [for y in range(2, local.height - 1) : "${local.end.x + 3};${local.end.y + y + 1};${local.end.z - local.pillar_position + local.height - y - 1};minecraft:redstone_torch"],
    [for y in range(2, local.height - 1) : "${local.end.x + 3};${local.end.y + y + 1};${local.end.z - local.pillar_position - local.height + y + 1};minecraft:redstone_torch"],

    # pillar 4
    [for y in range(2, local.height - 1) : "${local.end.x - 4};${local.end.y + y + 1};${local.end.z - local.pillar_position + local.height - y - 1};minecraft:redstone_torch"],
    [for y in range(2, local.height - 1) : "${local.end.x - 4};${local.end.y + y + 1};${local.end.z - local.pillar_position - local.height + y + 1};minecraft:redstone_torch"],
  ])

  # this is the fence that runs along the bridge runway
  fence = flatten([
    for z in range(local.start.z + 2 * local.height, local.end.z - 2 * local.height - 1) : [
      "${local.start.x - 3};${local.start.y + 3};${z};minecraft:pale_oak_fence",
      "${local.start.x + 2};${local.start.y + 3};${z};minecraft:pale_oak_fence",
    ]
  ])

  # torches placed on the bridge fence along the runway
  runway_lanterns = flatten([
    for z in range(local.start.z + 2 * local.height, local.end.z - 2 * local.height - 1) : [
      "${local.start.x - 3};${local.start.y + 4};${z};minecraft:redstone_torch",
      "${local.start.x + 2};${local.start.y + 4};${z};minecraft:redstone_torch",
    ]
  ])

  # hashicorp logo as a tunnel on the middle of the bridge
  hashicorp_coordinates = csvdecode(file("${path.module}/data/hashicorp.csv"))
  hashicorp = [
    for c in local.hashicorp_coordinates : "${local.start.x + tonumber(c.x) - 15},${local.start.y + tonumber(c.y)},${local.middle}"
  ]
}

resource "minecraft_block" "runway" {
  for_each = toset(local.runway)

  material = split(";", each.value)[3]

  position = {
    x = tonumber(split(";", each.value)[0])
    y = tonumber(split(";", each.value)[1])
    z = tonumber(split(";", each.value)[2])
  }
}

resource "minecraft_block" "fence" {
  for_each = toset(local.fence)

  material = split(";", each.value)[3]

  position = {
    x = tonumber(split(";", each.value)[0])
    y = tonumber(split(";", each.value)[1])
    z = tonumber(split(";", each.value)[2])
  }

  depends_on = [minecraft_block.runway]
}

resource "minecraft_block" "pillars" {
  for_each = toset(local.pillars)

  material = split(";", each.value)[3]

  position = {
    x = tonumber(split(";", each.value)[0])
    y = tonumber(split(";", each.value)[1])
    z = tonumber(split(";", each.value)[2])
  }

  depends_on = [minecraft_block.fence]
}

resource "minecraft_block" "suspension" {
  for_each = toset(local.suspension)

  material = split(";", each.value)[3]

  position = {
    x = tonumber(split(";", each.value)[0])
    y = tonumber(split(";", each.value)[1])
    z = tonumber(split(";", each.value)[2])
  }

  depends_on = [minecraft_block.pillars]
}

resource "minecraft_block" "suspension_lanterns" {
  for_each = toset(local.suspension_lanterns)

  material = split(";", each.value)[3]

  position = {
    x = tonumber(split(";", each.value)[0])
    y = tonumber(split(";", each.value)[1])
    z = tonumber(split(";", each.value)[2])
  }

  depends_on = [minecraft_block.suspension]
}

resource "minecraft_block" "runway_lanterns" {
  for_each = toset(local.runway_lanterns)

  material = split(";", each.value)[3]

  position = {
    x = tonumber(split(";", each.value)[0])
    y = tonumber(split(";", each.value)[1])
    z = tonumber(split(";", each.value)[2])
  }

  depends_on = [minecraft_block.suspension]
}

resource "minecraft_block" "hashicorp" {
  for_each = toset(local.hashicorp)

  material = "minecraft:glowstone"

  position = {
    x = tonumber(split(",", each.value)[0])
    y = tonumber(split(",", each.value)[1])
    z = tonumber(split(",", each.value)[2])
  }
}
