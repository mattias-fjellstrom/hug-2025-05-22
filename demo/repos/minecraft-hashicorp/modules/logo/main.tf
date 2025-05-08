locals {
  origin = {
    x = tonumber(split(",", var.origin)[0])
    y = tonumber(split(",", var.origin)[1])
    z = tonumber(split(",", var.origin)[2])
  }

  coordinates = [
    for c in var.coordinates : "${local.origin.x + tonumber(c.x)},${local.origin.y + tonumber(c.y)},${local.origin.z + tonumber(c.z)}"
  ]
}

resource "minecraft_block" "logo" {
  for_each = toset(local.coordinates)

  material = "minecraft:${var.material}"

  position = {
    x = tonumber(split(",", each.value)[0])
    y = tonumber(split(",", each.value)[1])
    z = tonumber(split(",", each.value)[2])
  }
}
