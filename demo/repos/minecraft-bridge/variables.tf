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
    error_message = "Limitation: y-coordinate must be the same for start and end"
  }

  validation {
    condition     = tonumber(split(",", var.start)[0]) == tonumber(split(",", var.end)[0])
    error_message = "Limitation: bridge must follow z direction (i.e. x1==x2)"
  }
}
