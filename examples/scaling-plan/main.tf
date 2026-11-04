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
  source  = "cloudnationhq/avd/azure"
  version = "~> 1.0"

  host_pool = {
    name                = module.naming.virtual_desktop_host_pool.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    type                = "Pooled"
    load_balancer_type  = "DepthFirst"

    scaling_plan = {
      name      = "vdscaling-demo-dev"
      time_zone = "W. Europe Standard Time"
      enabled   = true

      schedule = {
        weekdays = {
          name                                 = "Weekdays"
          days_of_week                         = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
          ramp_up_start_time                   = "06:00"
          ramp_up_load_balancing_algorithm     = "BreadthFirst"
          ramp_up_minimum_hosts_percent        = 20
          ramp_up_capacity_threshold_percent   = 10
          peak_start_time                      = "09:00"
          peak_load_balancing_algorithm        = "BreadthFirst"
          ramp_down_start_time                 = "18:00"
          ramp_down_load_balancing_algorithm   = "BreadthFirst"
          ramp_down_minimum_hosts_percent      = 10
          ramp_down_force_logoff_users         = false
          ramp_down_wait_time_minutes          = 45
          ramp_down_notification_message       = "Please log off in the next 45 minutes."
          ramp_down_capacity_threshold_percent = 5
          ramp_down_stop_hosts_when            = "ZeroSessions"
          off_peak_start_time                  = "22:00"
          off_peak_load_balancing_algorithm    = "BreadthFirst"
        }
      }
    }
  }
}
