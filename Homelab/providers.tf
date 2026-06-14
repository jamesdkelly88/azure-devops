terraform {
  required_version = ">= 1.0"

  cloud {
    organization = "jdkhomelab-ado"
    workspaces {
      name = "Homelab"
    }
  }

  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">= 1.15.1"
    }
    bitwarden-secrets = {
      source  = "bitwarden/bitwarden-secrets"
      version = "0.5.4-pre"
    }
  }
}

provider "bitwarden-secrets" {
  api_url      = "https://api.bitwarden.com"
  identity_url = "https://identity.bitwarden.com"
}