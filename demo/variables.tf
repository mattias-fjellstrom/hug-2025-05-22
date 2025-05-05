variable "aws_region" {
  type = string
}

variable "tfe_organization" {
  type = string
}

variable "github_organization" {
  type = string
}

variable "github_token" {
  type      = string
  sensitive = true
}

variable "hcp_project" {
  type = string
}
