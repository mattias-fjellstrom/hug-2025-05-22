variable "waypoint_application" {
  type        = string
  description = "Name of the Waypoint application."

  validation {
    condition     = !contains(["-", "_"], var.waypoint_application)
    error_message = "waypoint_application must not contain dashes or underscores."
  }
}

variable "domain" {
  type = string
}
