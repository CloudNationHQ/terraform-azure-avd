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
      enabled             = optional(bool)
      schedule = object({
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
      })
    }))
  })

  validation {
    condition     = lookup(var.host_pool, "location", null) != null || var.location != null
    error_message = "location must be set on var.host_pool.location or on the module-level var.location."
  }

  validation {
    condition     = lookup(var.host_pool, "resource_group_name", null) != null || var.resource_group_name != null
    error_message = "resource_group_name must be set on var.host_pool.resource_group_name or on the module-level var.resource_group_name."
  }

  validation {
    condition     = contains(["Personal", "Pooled"], var.host_pool.type)
    error_message = "type must be Personal or Pooled."
  }

  validation {
    condition     = contains(["BreadthFirst", "DepthFirst", "Persistent"], var.host_pool.load_balancer_type)
    error_message = "load_balancer_type must be BreadthFirst, DepthFirst or Persistent."
  }

  validation {
    condition     = var.host_pool.personal_desktop_assignment_type == null || contains(["Automatic", "Direct"], var.host_pool.personal_desktop_assignment_type)
    error_message = "personal_desktop_assignment_type must be Automatic or Direct."
  }

  validation {
    condition     = var.host_pool.preferred_app_group_type == null || contains(["Desktop", "RailApplications", "None"], var.host_pool.preferred_app_group_type)
    error_message = "preferred_app_group_type must be Desktop, RailApplications or None."
  }

  validation {
    condition     = var.host_pool.public_network_access == null || contains(["Enabled", "Disabled", "EnabledForSessionHostsOnly", "EnabledForClientsOnly"], var.host_pool.public_network_access)
    error_message = "public_network_access must be Enabled, Disabled, EnabledForSessionHostsOnly or EnabledForClientsOnly."
  }

  validation {
    condition     = alltrue([for g in values(var.host_pool.application_groups) : contains(["Desktop", "RemoteApp"], g.type)])
    error_message = "application_groups[*].type must be Desktop or RemoteApp."
  }

  validation {
    condition     = alltrue([for a in values(var.host_pool.applications) : contains(["DoNotAllow", "Allow", "Require"], a.command_line_argument_policy)])
    error_message = "applications[*].command_line_argument_policy must be DoNotAllow, Allow or Require."
  }

  validation {
    condition     = alltrue([for a in values(var.host_pool.applications) : contains(keys(var.host_pool.application_groups), a.application_group_key)])
    error_message = "applications[*].application_group_key must reference a key in application_groups."
  }

  validation {
    condition     = alltrue([for g in values(var.host_pool.application_groups) : g.workspace_key == null || contains(keys(var.host_pool.workspaces), g.workspace_key)])
    error_message = "application_groups[*].workspace_key must reference a key in workspaces."
  }
}
