locals {
  me = {
    id    = "jamesdkelly88"
    email = "jdk.homelab@gmail.com"
  }
  environments = [
    {
      name          = "Automatic"
      user_approval = false
    },
    {
      name          = "Manual"
      user_approval = true
    }
  ]
  pipelines = [
    {
      name            = "sleep-backup-server"
      folder          = "\\Backups"
      repository      = "ansible"
      repo_type       = "Bitbucket"
      branch          = "master"
      path            = ".azuredevops/pipelines/sleep-backup-server.yml"
      environments    = []
      pools           = []
      variable_groups = ["ansible"]
    },
    {
      name            = "wake-backup-server"
      folder          = "\\Backups"
      repository      = "ansible"
      repo_type       = "Bitbucket"
      branch          = "master"
      path            = ".azuredevops/pipelines/wake-backup-server.yml"
      environments    = []
      pools           = []
      variable_groups = ["ansible"]
    },
    {
      name            = "renew-letsencrypt"
      folder          = "\\Certificates"
      repository      = "ansible"
      repo_type       = "Bitbucket"
      branch          = "master"
      path            = ".azuredevops/pipelines/renew-letsencrypt.yml"
      environments    = []
      pools           = []
      variable_groups = ["ansible", "letsencrypt"]
    },
    {
      name            = "manual-role"
      folder          = "\\Deploy"
      repository      = "ansible-lab"
      repo_type       = "GitHub"
      branch          = "main"
      path            = ".azuredevops/pipelines/manual-role.yml"
      environments    = []
      pools           = []
      variable_groups = ["ansible"]
    },
    {
      name            = "build-docs"
      folder          = "\\Documentation"
      repository      = "documentation"
      repo_type       = "GitHub"
      branch          = "main"
      path            = ".azuredevops/pipelines/build-docs.yml"
      environments    = []
      pools           = []
      variable_groups = []
    },
    {
      name            = "update-games"
      folder          = "\\Documentation"
      repository      = "documentation"
      repo_type       = "GitHub"
      branch          = "main"
      path            = ".azuredevops/pipelines/update-games.yml"
      environments    = []
      pools           = []
      variable_groups = []
    },
    {
      name            = "Pester"
      folder          = "\\Kubernetes"
      repository      = "k8s"
      repo_type       = "Bitbucket"
      branch          = "feature/multi-cluster"
      path            = ".azuredevops/pipelines/pester.yml"
      environments    = []
      pools           = []
      variable_groups = []
    },
    {
      name            = "Test"
      folder          = "\\Kubernetes"
      repository      = "k8s"
      repo_type       = "Bitbucket"
      branch          = "main"
      path            = ".azuredevops/pipelines/change_test.yml"
      environments    = []
      pools           = []
      variable_groups = []
    },
    {
      name            = "heartbeat"
      folder          = "\\Monitoring"
      repository      = "ansible-lab"
      repo_type       = "GitHub"
      branch          = "main"
      path            = ".azuredevops/pipelines/heartbeat.yml"
      environments    = []
      pools           = []
      variable_groups = ["ansible"]
    },
    {
      name            = "ip-address"
      folder          = "\\Network"
      repository      = "ansible"
      repo_type       = "Bitbucket"
      branch          = "master"
      path            = ".azuredevops/pipelines/ip-address.yaml"
      environments    = []
      pools           = []
      variable_groups = ["ansible"]
    },
    {
      name            = "netbox-dhcp"
      folder          = "\\Network"
      repository      = "ansible-lab"
      repo_type       = "GitHub"
      branch          = "main"
      path            = ".azuredevops/pipelines/netbox-dhcp.yml"
      environments    = []
      pools           = []
      variable_groups = ["ansible"]
    },
    {
      name            = "patching"
      folder          = "\\Patching"
      repository      = "ansible-lab"
      repo_type       = "GitHub"
      branch          = "main"
      path            = ".azuredevops/pipelines/patching.yml"
      environments    = []
      pools           = []
      variable_groups = ["ansible"]
    },
    {
      name            = "update-host"
      folder          = "\\Patching"
      repository      = "ansible"
      repo_type       = "Bitbucket"
      branch          = "master"
      path            = ".azuredevops/pipelines/update-host.yml"
      environments    = []
      pools           = ["Default"]
      variable_groups = ["ansible"]
    },
    {
      name            = "reboot-host"
      folder          = "\\Power Management"
      repository      = "ansible"
      repo_type       = "Bitbucket"
      branch          = "master"
      path            = ".azuredevops/pipelines/reboot-host.yml"
      environments    = []
      pools           = []
      variable_groups = ["ansible"]
    },
    {
      name            = "sleep"
      folder          = "\\Power Management"
      repository      = "ansible"
      repo_type       = "Bitbucket"
      branch          = "master"
      path            = ".azuredevops/pipelines/sleep.yml"
      environments    = []
      pools           = []
      variable_groups = ["ansible"]
    },
    {
      name            = "wake"
      folder          = "\\Power Management"
      repository      = "ansible"
      repo_type       = "Bitbucket"
      branch          = "master"
      path            = ".azuredevops/pipelines/wake.yml"
      environments    = []
      pools           = []
      variable_groups = ["ansible"]
    },
    {
      name            = "Build VM"
      folder          = "\\VM"
      repository      = "terraform"
      repo_type       = "Bitbucket"
      branch          = "master"
      path            = ".azuredevops/pipelines/build_vm.yaml"
      environments    = ["Automatic", "Manual"]
      pools           = []
      variable_groups = ["ansible", "terraform"]
    },
    {
      name            = "Destroy VM"
      folder          = "\\VM"
      repository      = "terraform"
      repo_type       = "Bitbucket"
      branch          = "master"
      path            = ".azuredevops/pipelines/destroy_vm.yaml"
      environments    = ["Manual"]
      pools           = []
      variable_groups = ["ansible", "terraform"]
    }
  ]
  pools = [
    "Default",
    "k8s-dev",
    "k8s-local",
    "k8s-prd"
  ]
  variable_groups = {
    ansible = {
      variables = {
        ansible_host = "rp08"
        hyperv_host  = "dt04"
        nested_host  = "dt02"
        proxmox_host = "dt03"
        vault_file   = "~/.vaultpw"
        xen_host     = "dt08"
      }
      secrets = {
        bitwarden_token = "edc75c89-6795-4302-8362-b467013b615e"
        vault_password  = "84bdfd70-7a2c-45c7-82d4-b469009e4dcb"
      }
    }
    letsencrypt = {
      variables = {}
      secrets = {
        akeyless_id   = "ac3e9f52-a90e-44ce-b2e1-b46900a15849"
        akeyless_key  = "3eebddbc-07a3-45f3-9278-b46900a0271d"
        duckdns_token = "576d4d12-5454-4acc-b4c6-b46900a198b7"
      }
    }
    terraform = {
      variables = {
        plugin_cache   = "/azuredevops/terraform.d/plugin-cache"
        proxmox_user   = "root@pam"
        terraform_host = "rp08"
      }
      secrets = {
        proxmox_password = "f5a9890e-949c-4fd5-9498-b46900a2a48f"
        terraform_token  = "5385509a-a668-4caa-af70-b46900a2ee0d"
      }
    }
  }
}