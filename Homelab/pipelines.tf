resource "azuredevops_build_definition" "pipeline" {
  for_each   = { for pipeline in local.pipelines : pipeline.name => pipeline }
  project_id = data.azuredevops_project.project.id
  name       = each.value.name
  path       = each.value.folder
  ci_trigger {
    use_yaml = true
  }
  dynamic "pull_request_trigger" {
    for_each = each.value.repo_type != "TfsGit" ? toset([1]) : []
    content {
      initial_branch = each.value.branch
      use_yaml       = true
      forks {
        enabled       = false
        share_secrets = false
      }
    }
  }
  repository {
    repo_type = each.value.repo_type
    repo_id = (
      each.value.repo_type == "TfsGit" ?
      [for r in data.azuredevops_git_repositories.repos.repositories : r.id if r.name == each.value.repository][0] :
      "${local.me.id}/${each.value.repository}"
    )
    branch_name = "refs/heads/${each.value.branch}"
    yml_path    = each.value.path
    service_connection_id = (
      each.value.repo_type == "Bitbucket" ? data.azuredevops_serviceendpoint_bitbucket.ep.id :
      each.value.repo_type == "GitHub" ? data.azuredevops_serviceendpoint_github.ep.id :
      null
    )
  }

}

resource "azuredevops_pipeline_authorization" "queue_access" {
  for_each    = { for x in local.pipeline_pools : "${x.pipeline_name}.${x.queue_name}" => x }
  project_id  = data.azuredevops_project.project.id
  resource_id = each.value.queue_id
  type        = "queue"
  pipeline_id = each.value.pipeline_id
  depends_on  = [azuredevops_agent_queue.queue, azuredevops_build_definition.pipeline]
}

resource "azuredevops_pipeline_authorization" "vg_access" {
  for_each    = { for x in local.pipeline_vars : "${x.pipeline_name}.${x.group_name}" => x }
  project_id  = data.azuredevops_project.project.id
  resource_id = each.value.group_id
  type        = "variablegroup"
  pipeline_id = each.value.pipeline_id
  depends_on  = [azuredevops_build_definition.pipeline, azuredevops_variable_group.group]
}

resource "azuredevops_pipeline_authorization" "env_access" {
  for_each    = { for x in local.pipeline_envs : "${x.pipeline_name}.${x.env_name}" => x }
  project_id  = data.azuredevops_project.project.id
  resource_id = each.value.env_id
  type        = "environment"
  pipeline_id = each.value.pipeline_id
  depends_on  = [azuredevops_build_definition.pipeline, azuredevops_environment.environment]
}

locals {
  pipeline_envs = flatten([
    for p in local.pipelines : [
      for e in p.environments : {
        pipeline_name = p.name
        pipeline_id   = azuredevops_build_definition.pipeline[p.name].id
        env_name      = e
        env_id        = azuredevops_environment.environment[e].id
      }
    ]
  ])
  pipeline_pools = flatten([
    for p in local.pipelines : [
      for q in p.pools : {
        pipeline_name = p.name
        pipeline_id   = azuredevops_build_definition.pipeline[p.name].id
        queue_name    = q
        queue_id      = azuredevops_agent_queue.queue[q].id
      }
    ]
  ])
  pipeline_vars = flatten([
    for p in local.pipelines : [
      for v in p.variable_groups : {
        pipeline_name = p.name
        pipeline_id   = azuredevops_build_definition.pipeline[p.name].id
        group_name    = v
        group_id      = azuredevops_variable_group.group[v].id
      }
    ]
  ])
}