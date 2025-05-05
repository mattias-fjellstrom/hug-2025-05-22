# --------------------------------------------------------------------------------------------------
# Workload identity federation AWS <---> HCP
# --------------------------------------------------------------------------------------------------
data "hcp_project" "current" {}

resource "hcp_service_principal" "aws" {
  name   = "hug-aws"
  parent = data.hcp_project.current.resource_name
}

resource "hcp_project_iam_binding" "aws" {
  principal_id = hcp_service_principal.aws.resource_id
  role         = "roles/admin"
}

locals {
  minecraft_iam_role_prefix = "waypoint-minecraft-"
  arn_expression = join(":", [
    "arn",
    "aws",
    "sts",
    "",
    data.aws_caller_identity.current.account_id,
    "assumed-role/${local.minecraft_iam_role_prefix}*"
  ])
}

resource "hcp_iam_workload_identity_provider" "aws" {
  name              = "aws"
  service_principal = hcp_service_principal.aws.resource_name
  aws = {
    account_id = data.aws_caller_identity.current.account_id
  }
  conditional_access = "aws.arn matches `^${local.arn_expression}`"
}

# --------------------------------------------------------------------------------------------------
# Workload identity federation TFE <---> AWS
# --------------------------------------------------------------------------------------------------
data "tls_certificate" "provider" {
  url = "https://app.terraform.io"
}

resource "aws_iam_openid_connect_provider" "hcp_terraform" {
  url = "https://app.terraform.io"

  client_id_list = [
    "aws.workload.identity",
  ]

  thumbprint_list = [
    data.tls_certificate.provider.certificates[0].sha1_fingerprint,
  ]
}

data "aws_iam_policy_document" "hcp_terraform_oidc" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.hcp_terraform.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "app.terraform.io:aud"
      values   = ["aws.workload.identity"]
    }

    condition {
      test     = "StringLike"
      variable = "app.terraform.io:sub"
      values   = ["organization:${var.tfe_organization}:project:${tfe_project.hug.name}:workspace:*"]
    }
  }
}

resource "aws_iam_role" "hcp_terraform_oidc" {
  name               = "hcp-terraform"
  assume_role_policy = data.aws_iam_policy_document.hcp_terraform_oidc.json
}

data "aws_iam_policy" "administrator_access" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "administrator_access" {
  policy_arn = data.aws_iam_policy.administrator_access.arn
  role       = aws_iam_role.hcp_terraform_oidc.name
}

resource "tfe_variable_set" "aws" {
  name = "AWS-OIDC"
}

resource "tfe_project_variable_set" "aws" {
  variable_set_id = tfe_variable_set.aws.id
  project_id      = tfe_project.hug.id
}

resource "tfe_variable" "tfc_aws_provider_auth" {
  key             = "TFC_AWS_PROVIDER_AUTH"
  value           = "true"
  category        = "env"
  variable_set_id = tfe_variable_set.aws.id
}

resource "tfe_variable" "tfc_aws_run_role_arn" {
  key             = "TFC_AWS_RUN_ROLE_ARN"
  value           = aws_iam_role.hcp_terraform_oidc.arn
  category        = "env"
  variable_set_id = tfe_variable_set.aws.id
}

# --------------------------------------------------------------------------------------------------
# Workload identity federation TFE <---> HCP
# --------------------------------------------------------------------------------------------------
resource "hcp_service_principal" "hcp_terraform" {
  name   = "hug-hcp-terraform"
  parent = data.hcp_project.current.resource_name
}

resource "hcp_project_iam_binding" "hcp_terraform" {
  principal_id = hcp_service_principal.hcp_terraform.resource_id
  role         = "roles/contributor"
}

locals {
  match_expr = join(":", [
    "organization",
    var.tfe_organization,
    "project",
    tfe_project.hug.name,
    "workspace",
    "*"
  ])
  hcp_audience = "hcp.workload.identity"
}

resource "hcp_iam_workload_identity_provider" "hcp_terraform" {
  name              = "hcp-terraform-project-${tfe_project.hug.name}"
  description       = "For HCP Terraform auth"
  service_principal = hcp_service_principal.hcp_terraform.resource_name
  oidc = {
    issuer_uri        = "https://app.terraform.io"
    allowed_audiences = [local.hcp_audience]
  }
  conditional_access = "jwt_claims.sub matches `^${local.match_expr}`"
}

resource "tfe_variable_set" "hcp" {
  name = "HCP-OIDC"
}

resource "tfe_project_variable_set" "hcp" {
  variable_set_id = tfe_variable_set.hcp.id
  project_id      = tfe_project.hug.id
}

resource "tfe_variable" "tfc_hcp_provider_auth" {
  key             = "TFC_HCP_PROVIDER_AUTH"
  value           = "true"
  category        = "env"
  variable_set_id = tfe_variable_set.hcp.id
}

resource "tfe_variable" "tfc_hcp_run_provider_resource_name" {
  key             = "TFC_HCP_RUN_PROVIDER_RESOURCE_NAME"
  value           = hcp_iam_workload_identity_provider.hcp_terraform.resource_name
  category        = "env"
  variable_set_id = tfe_variable_set.hcp.id
}

resource "tfe_variable" "tfc_hcp_workload_identity_audience" {
  key             = "TFC_HCP_WORKLOAD_IDENTITY_AUDIENCE"
  value           = local.hcp_audience
  category        = "env"
  variable_set_id = tfe_variable_set.hcp.id
}
