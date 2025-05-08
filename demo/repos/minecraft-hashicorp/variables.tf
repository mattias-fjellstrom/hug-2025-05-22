variable "waypoint_application" {
  type = string
}

variable "waypoint_add_on" {
  type = string
}

variable "waypoint_add_on_definition" {
  type = string
}

variable "origin" {
  type = string

  validation {
    condition     = length(split(",", var.origin)) == 3
    error_message = "Specify three coordinates (x,y,z)"
  }
}

variable "logo" {
  type = string

  validation {
    condition = contains([
      "hashicorp",
      "terraform",
      "vault",
      "boundary",
      "waypoint",
      "packer",
      "consul",
      "nomad",
      "vagrant"
    ], var.logo)
    error_message = "Use an approved value"
  }
}
