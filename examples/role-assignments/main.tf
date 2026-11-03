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

data "azurerm_client_config" "current" {}

module "avd" {
  source = "../../"

  host_pool = {
    name                = module.naming.virtual_desktop_host_pool.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    type                = "Pooled"
    load_balancer_type  = "BreadthFirst"

    role_assignments = {
      contributor = {
        role_definition_id_or_name = "Desktop Virtualization Host Pool Contributor"
        principal_id               = data.azurerm_client_config.current.object_id
      }
    }

    application_groups = {
      desktop = {
        name = module.naming.virtual_desktop_application_group.name_unique
        type = "Desktop"

        role_assignments = {
          user = {
            role_definition_id_or_name = "Desktop Virtualization User"
            principal_id               = data.azurerm_client_config.current.object_id
          }
        }
      }
    }
  }
}
