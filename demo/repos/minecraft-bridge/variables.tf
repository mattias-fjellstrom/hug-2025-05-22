variable "waypoint_application" {
  type = string
}

variable "waypoint_add_on" {
  type = string
}

variable "waypoint_add_on_definition" {
  type = string
}

variable "start" {
  type = string
}

variable "end" {
  type = string

  validation {
    condition     = tonumber(split(",", var.start)[1]) == tonumber(split(",", var.end)[1])
    error_message = "y-coordinate must be the same for start and end"
  }

  validation {
    condition     = tonumber(split(",", var.start)[0]) == tonumber(split(",", var.end)[0]) || tonumber(split(",", var.start)[2]) == tonumber(split(",", var.end)[2])
    error_message = "bridge must follow either x or z direction (i.e. x1==x2 or z1==z2)"
  }
}
