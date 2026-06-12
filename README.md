# Azure DevOps

This repository contains the Terraform definitions of my Azure DevOps project, including:

- Environments
- Pipelines
- Pools
- Variable Groups

## Running

### Manual

- Popualate `.env` file:
  - AZDO_ORG_SERVICE_URL (dev.azure.com URL)
  - AZDO_PERSONAL_ACCESS_TOKEN (Your own PAT)
  - BW_ACCESS_TOKEN (Bitwarden Secrets Manager API key)
  - BW_ORGANIZATION_ID (Bitwarden Secrets Manager organization GUID)
  - TF_TOKEN_app_terraform_io (Token from Terraform Cloud for state storage)
- Run `task plan`
- Run `task apply`


### Automatic

TODO: There will be a pipeline that automatically applies the Terraform on commit to main, running on a on-premise worker agent. (Needs to run with enough permissions to make org changes using a temporary token)