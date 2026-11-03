# application groups
resource "azurerm_virtual_desktop_application_group" "this" {
  for_each = var.host_pool.application_groups

  resource_group_name = coalesce(
    each.value.resource_group_name, var.host_pool.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    each.value.location, var.host_pool.location, var.location
  )

  tags = coalesce(
    each.value.tags, var.host_pool.tags, var.tags
  )

  name                         = each.value.name
  type                         = each.value.type
  host_pool_id                 = azurerm_virtual_desktop_host_pool.this.id
  friendly_name                = each.value.friendly_name
  description                  = each.value.description
  default_desktop_display_name = each.value.default_desktop_display_name
}

# applications
resource "azurerm_virtual_desktop_application" "this" {
  for_each = var.host_pool.applications

  name                         = each.value.name
  application_group_id         = azurerm_virtual_desktop_application_group.this[each.value.application_group_key].id
  friendly_name                = each.value.friendly_name
  description                  = each.value.description
  path                         = each.value.path
  command_line_argument_policy = each.value.command_line_argument_policy
  command_line_arguments       = each.value.command_line_arguments
  show_in_portal               = each.value.show_in_portal
  icon_path                    = each.value.icon_path
  icon_index                   = each.value.icon_index
}

# workspaces
resource "azurerm_virtual_desktop_workspace" "this" {
  for_each = var.host_pool.workspaces

  resource_group_name = coalesce(
    each.value.resource_group_name, var.host_pool.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    each.value.location, var.host_pool.location, var.location
  )

  tags = coalesce(
    each.value.tags, var.host_pool.tags, var.tags
  )

  name                          = each.value.name
  friendly_name                 = each.value.friendly_name
  description                   = each.value.description
  public_network_access_enabled = each.value.public_network_access_enabled
}

# workspace application group associations
resource "azurerm_virtual_desktop_workspace_application_group_association" "this" {
  for_each = { for k, v in var.host_pool.application_groups : k => v if v.workspace_key != null }

  workspace_id         = azurerm_virtual_desktop_workspace.this[each.value.workspace_key].id
  application_group_id = azurerm_virtual_desktop_application_group.this[each.key].id
}

# host pool
resource "azurerm_virtual_desktop_host_pool" "this" {
  resource_group_name = coalesce(
    var.host_pool.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    var.host_pool.location, var.location
  )

  tags = coalesce(
    var.host_pool.tags, var.tags
  )

  name                             = var.host_pool.name
  type                             = var.host_pool.type
  load_balancer_type               = var.host_pool.load_balancer_type
  validate_environment             = var.host_pool.validate_environment
  friendly_name                    = var.host_pool.friendly_name
  description                      = var.host_pool.description
  custom_rdp_properties            = var.host_pool.custom_rdp_properties
  maximum_sessions_allowed         = var.host_pool.maximum_sessions_allowed
  personal_desktop_assignment_type = var.host_pool.personal_desktop_assignment_type
  preferred_app_group_type         = var.host_pool.preferred_app_group_type
  public_network_access            = var.host_pool.public_network_access
  start_vm_on_connect              = var.host_pool.start_vm_on_connect
  vm_template                      = var.host_pool.vm_template

  dynamic "scheduled_agent_updates" {
    for_each = var.host_pool.scheduled_agent_updates != null ? { "this" = var.host_pool.scheduled_agent_updates } : {}

    content {
      enabled                   = scheduled_agent_updates.value.enabled
      timezone                  = scheduled_agent_updates.value.timezone
      use_session_host_timezone = scheduled_agent_updates.value.use_session_host_timezone

      dynamic "schedule" {
        for_each = scheduled_agent_updates.value.schedule

        content {
          day_of_week = schedule.value.day_of_week
          hour_of_day = schedule.value.hour_of_day
        }
      }
    }
  }
}

# scaling plan
resource "azurerm_virtual_desktop_scaling_plan" "this" {
  for_each = var.host_pool.scaling_plan != null ? { "this" = var.host_pool.scaling_plan } : {}

  resource_group_name = coalesce(
    each.value.resource_group_name, var.host_pool.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    each.value.location, var.host_pool.location, var.location
  )

  tags = coalesce(
    each.value.tags, var.host_pool.tags, var.tags
  )

  name          = each.value.name
  friendly_name = each.value.friendly_name
  description   = each.value.description
  time_zone     = each.value.time_zone
  exclusion_tag = each.value.exclusion_tag

  schedule {
    name                                 = each.value.schedule.name
    days_of_week                         = each.value.schedule.days_of_week
    ramp_up_start_time                   = each.value.schedule.ramp_up_start_time
    ramp_up_load_balancing_algorithm     = each.value.schedule.ramp_up_load_balancing_algorithm
    ramp_up_minimum_hosts_percent        = each.value.schedule.ramp_up_minimum_hosts_percent
    ramp_up_capacity_threshold_percent   = each.value.schedule.ramp_up_capacity_threshold_percent
    peak_start_time                      = each.value.schedule.peak_start_time
    peak_load_balancing_algorithm        = each.value.schedule.peak_load_balancing_algorithm
    ramp_down_start_time                 = each.value.schedule.ramp_down_start_time
    ramp_down_load_balancing_algorithm   = each.value.schedule.ramp_down_load_balancing_algorithm
    ramp_down_minimum_hosts_percent      = each.value.schedule.ramp_down_minimum_hosts_percent
    ramp_down_force_logoff_users         = each.value.schedule.ramp_down_force_logoff_users
    ramp_down_wait_time_minutes          = each.value.schedule.ramp_down_wait_time_minutes
    ramp_down_notification_message       = each.value.schedule.ramp_down_notification_message
    ramp_down_capacity_threshold_percent = each.value.schedule.ramp_down_capacity_threshold_percent
    ramp_down_stop_hosts_when            = each.value.schedule.ramp_down_stop_hosts_when
    off_peak_start_time                  = each.value.schedule.off_peak_start_time
    off_peak_load_balancing_algorithm    = each.value.schedule.off_peak_load_balancing_algorithm
  }
}

# scaling plan host pool association
resource "azurerm_virtual_desktop_scaling_plan_host_pool_association" "this" {
  for_each = var.host_pool.scaling_plan != null ? { "this" = var.host_pool.scaling_plan } : {}

  host_pool_id    = azurerm_virtual_desktop_host_pool.this.id
  scaling_plan_id = azurerm_virtual_desktop_scaling_plan.this["this"].id
  enabled         = each.value.enabled
}

# registration info
resource "azurerm_virtual_desktop_host_pool_registration_info" "this" {
  for_each = var.host_pool.registration_info != null ? { "this" = var.host_pool.registration_info } : {}

  hostpool_id     = azurerm_virtual_desktop_host_pool.this.id
  expiration_date = each.value.expiration_date
}

# role assignments
resource "azurerm_role_assignment" "this" {
  for_each = merge(
    { for k, v in var.host_pool.role_assignments : "host_pool.${k}" => merge(v, { scope = azurerm_virtual_desktop_host_pool.this.id }) },
    merge([for gk, g in var.host_pool.application_groups : { for k, v in g.role_assignments : "application_groups.${gk}.${k}" => merge(v, { scope = azurerm_virtual_desktop_application_group.this[gk].id }) }]...),
    merge([for wk, w in var.host_pool.workspaces : { for k, v in w.role_assignments : "workspaces.${wk}.${k}" => merge(v, { scope = azurerm_virtual_desktop_workspace.this[wk].id }) }]...)
  )

  scope                                  = each.value.scope
  principal_id                           = each.value.principal_id
  role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), "/providers/microsoft.authorization/roledefinitions/") ? each.value.role_definition_id_or_name : null
  role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), "/providers/microsoft.authorization/roledefinitions/") ? null : each.value.role_definition_id_or_name
  description                            = each.value.description
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  principal_type                         = each.value.principal_type
}

# diagnostic settings
resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each = merge(
    { for k, v in var.host_pool.diagnostic_settings : "host_pool.${k}" => merge(v, { target_resource_id = azurerm_virtual_desktop_host_pool.this.id }) },
    merge([for gk, g in var.host_pool.application_groups : { for k, v in g.diagnostic_settings : "application_groups.${gk}.${k}" => merge(v, { target_resource_id = azurerm_virtual_desktop_application_group.this[gk].id }) }]...),
    merge([for wk, w in var.host_pool.workspaces : { for k, v in w.diagnostic_settings : "workspaces.${wk}.${k}" => merge(v, { target_resource_id = azurerm_virtual_desktop_workspace.this[wk].id }) }]...)
  )

  name                           = each.value.name
  target_resource_id             = each.value.target_resource_id
  log_analytics_workspace_id     = each.value.log_analytics_workspace_id
  storage_account_id             = each.value.storage_account_id
  eventhub_authorization_rule_id = each.value.eventhub_authorization_rule_id
  eventhub_name                  = each.value.eventhub_name

  dynamic "enabled_log" {
    for_each = each.value.log_categories

    content {
      category = enabled_log.value
    }
  }

  dynamic "enabled_log" {
    for_each = each.value.log_groups

    content {
      category_group = enabled_log.value
    }
  }

  dynamic "enabled_metric" {
    for_each = each.value.metric_categories

    content {
      category = enabled_metric.value
    }
  }
}
