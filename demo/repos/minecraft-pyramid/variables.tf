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

variable "width" {
  type = number

  validation {
    condition     = var.width % 2 == 1
    error_message = "Use an odd numbered width (5, 7, 13, 21, etc)"
  }
}

variable "material" {
  type = string
}
