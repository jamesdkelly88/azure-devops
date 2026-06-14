data "azuredevops_project" "project" {
  name = "Homelab"
}

data "azuredevops_users" "me" {
  principal_name = local.me.email
}

locals {
  secrets = flatten([
    for group_name, group in local.variable_groups : [
      for secret_name, secret_id in group.secrets : {
        group  = group_name
        name   = secret_name
        secret = secret_id
      }
    ]
  ])
}

data "bitwarden-secrets_secret" "secrets" {
  for_each = {
    for secret in local.secrets : "${secret.group}.${secret.name}" => secret
  }
  id = each.value.secret
}

data "azuredevops_serviceendpoint_github" "ep" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = "github"
}

data "azuredevops_serviceendpoint_bitbucket" "ep" {
  project_id            = data.azuredevops_project.project.id
  service_endpoint_name = "bitbucket"
}

data "azuredevops_git_repositories" "repos" {
  project_id = data.azuredevops_project.project.id
}