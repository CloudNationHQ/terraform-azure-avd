variable "location" {
  description = "default azure region to be used."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "default resource group to be used."
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
variable "host_pool" {
  description = "contains all virtual desktop host pool configuration"
  type = object({
    name                             = string
    resource_group_name              = optional(string)
    location                         = optional(string)
    tags                             = optional(map(string))
    type                             = string
    load_balancer_type               = string
    validate_environment             = optional(bool)
    friendly_name                    = optional(string)
    description                      = optional(string)
    custom_rdp_properties            = optional(string)
    maximum_sessions_allowed         = optional(number)
    personal_desktop_assignment_type = optional(string)
    preferred_app_group_type         = optional(string)
    public_network_access            = optional(string)
    start_vm_on_connect              = optional(bool)
    vm_template                      = optional(string)
    scheduled_agent_updates = optional(object({
      enabled                   = optional(bool)
      timezone                  = optional(string)
      use_session_host_timezone = optional(bool)
      schedule = optional(map(object({
        day_of_week = string
        hour_of_day = number
      })), {})
    }))
    registration_info = optional(object({
      expiration_date = string
    }))
    application_groups = optional(map(object({
      name                         = string
      type                         = string
      resource_group_name          = optional(string)
      location                     = optional(string)
      tags                         = optional(map(string))
      friendly_name                = optional(string)
      description                  = optional(string)
      default_desktop_display_name = optional(string)
      workspace_key                = optional(string)
    })), {})
    applications = optional(map(object({
      name                         = string
      application_group_key        = string
      path                         = string
      command_line_argument_policy = string
      command_line_arguments       = optional(string)
      friendly_name                = optional(string)
      description                  = optional(string)
      icon_path                    = optional(string)
      icon_index                   = optional(number)
      show_in_portal               = optional(bool)
    })), {})
    workspaces = optional(map(object({
      name                          = string
      resource_group_name           = optional(string)
      location                      = optional(string)
      tags                          = optional(map(string))
      friendly_name                 = optional(string)
      description                   = optional(string)
      public_network_access_enabled = optional(bool)
    })), {})
    scaling_plan = optional(object({
      name                = string
      time_zone           = string
      resource_group_name = optional(string)
      location            = optional(string)
      tags                = optional(map(string))
      friendly_name       = optional(string)
      description         = optional(string)
      exclusion_tag       = optional(string)
      enabled             = bool
      schedule = map(object({
        name                                 = string
        days_of_week                         = set(string)
        ramp_up_start_time                   = string
        ramp_up_load_balancing_algorithm     = string
        ramp_up_minimum_hosts_percent        = optional(number)
        ramp_up_capacity_threshold_percent   = optional(number)
        peak_start_time                      = string
        peak_load_balancing_algorithm        = string
        ramp_down_start_time                 = string
        ramp_down_load_balancing_algorithm   = string
        ramp_down_minimum_hosts_percent      = number
        ramp_down_force_logoff_users         = bool
        ramp_down_wait_time_minutes          = number
        ramp_down_notification_message       = string
        ramp_down_capacity_threshold_percent = number
        ramp_down_stop_hosts_when            = string
        off_peak_start_time                  = string
        off_peak_load_balancing_algorithm    = string
      }))
    }))
  })
}