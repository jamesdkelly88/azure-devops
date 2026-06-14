resource "azuredevops_variable_group" "group" {
  for_each     = tomap(local.variable_groups)
  project_id   = data.azuredevops_project.project.id
  name         = each.key
  description  = ""
  allow_access = false

  dynamic "variable" {
    for_each = each.value.variables
    content {
      name  = variable.key
      value = variable.value
    }
  }

  dynamic "variable" {
    for_each = each.value.secrets
    content {
      name         = variable.key
      is_secret    = true
      secret_value = data.bitwarden-secrets_secret.secrets["${each.key}.${variable.key}"].value
    }
  }
}




