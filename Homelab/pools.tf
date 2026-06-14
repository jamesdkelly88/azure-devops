resource "azuredevops_agent_pool" "pool" {
  for_each       = { for pool in local.pools : pool => pool }
  name           = each.value
  auto_provision = false
  auto_update    = true
}

resource "azuredevops_agent_queue" "queue" {
  for_each      = { for pool in local.pools : pool => pool }
  project_id    = data.azuredevops_project.project.id
  agent_pool_id = azuredevops_agent_pool.pool[each.value].id
}