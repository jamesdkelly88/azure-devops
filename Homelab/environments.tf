resource "azuredevops_environment" "environment" {
  for_each   = { for environment in local.environments : environment.name => environment }
  project_id = data.azuredevops_project.project.id
  name       = each.key
}

resource "azuredevops_check_approval" "approvers" {
  for_each              = { for environment in local.environments : environment.name => environment if environment.user_approval }
  project_id            = data.azuredevops_project.project.id
  target_resource_id    = azuredevops_environment.environment[each.key].id
  target_resource_type  = "environment"
  requester_can_approve = true
  approvers             = data.azuredevops_users.me.users[*].id
}