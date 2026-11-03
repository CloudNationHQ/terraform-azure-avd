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

module "avd" {
  source = "../../"

  host_pool = {
    name                     = module.naming.virtual_desktop_host_pool.name_unique
    location                 = module.rg.groups.demo.location
    resource_group_name      = module.rg.groups.demo.name
    type                     = "Pooled"
    load_balancer_type       = "BreadthFirst"
    maximum_sessions_allowed = 10
    validate_environment     = true
    custom_rdp_properties    = "audiocapturemode:i:1;audiomode:i:0;"

    registration_info = {
      expiration_date = timeadd(timestamp(), "48h")
    }

    scheduled_agent_updates = {
      enabled  = true
      timezone = "W. Europe Standard Time"
      schedule = {
        saturday = {
          day_of_week = "Saturday"
          hour_of_day = 2
        }
      }
    }
  }
}
