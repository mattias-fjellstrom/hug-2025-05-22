resource "hcp_project" "hug" {
  name        = "hug"
  description = "Demo project for the HashiCorp User Group"
}

resource "local_file" "hcp_auto_tfvars" {
  filename = "../demo/hcp.auto.tfvars"
  content  = <<-EOF
  hcp_project = "${hcp_project.hug.resource_id}"
  EOF
}
