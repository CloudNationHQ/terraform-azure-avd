module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.25"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 3.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "law" {
  source  = "cloudnationhq/law/azure"
  version = "~> 4.0"

  workspace = {
    name                = module.naming.log_analytics_workspace.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
  }
}

module "avd" {
  source = "../../"

  host_pool = {
    name                = module.naming.virtual_desktop_host_pool.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    type                = "Pooled"
    load_balancer_type  = "BreadthFirst"

    diagnostic_settings = {
      law = {
        name                       = "diag-hostpool"
        log_analytics_workspace_id = module.law.workspace.id
        metric_categories          = []
      }
    }

    workspaces = {
      demo = {
        name = module.naming.virtual_desktop_workspace.name_unique

        diagnostic_settings = {
          law = {
            name                       = "diag-workspace"
            log_analytics_workspace_id = module.law.workspace.id
            metric_categories          = []
          }
        }
      }
    }
  }
}
