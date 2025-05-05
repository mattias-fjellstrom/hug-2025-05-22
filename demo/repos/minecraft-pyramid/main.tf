locals {
  input_coordinate = split(",", var.origin)

  origin = {
    x = tonumber(local.input_coordinate[0])
    y = tonumber(local.input_coordinate[1])
    z = tonumber(local.input_coordinate[2])
  }

  width  = var.width
  height = floor(local.width / 2) + 1

  auto_base = compact(flatten([
    for h in range(local.height) : [
      for x in range(h, local.width - h) : [
        for z in range(h, local.width - h) : x == h || x == local.width - h - 1 || z == h || z == local.width - h - 1 ? "${local.origin.x + x},${local.origin.y + h},${local.origin.z + z}" : null
      ]
    ]
  ]))
}


resource "minecraft_block" "pyramid" {
  for_each = toset(local.auto_base)
  material = "minecraft:${var.material}"
  position = {
    x = tonumber(split(",", each.value)[0])
    y = tonumber(split(",", each.value)[1])
    z = tonumber(split(",", each.value)[2])
  }
}
