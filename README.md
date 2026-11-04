# Virtual Desktop

This Terraform module streamlines the creation and administration of Azure Virtual Desktop resources, offering customizable options for host pools, application groups, applications, workspaces and scaling plans, to provide a consistent and repeatable virtual desktop platform in the cloud.

## Features

Supports pooled and personal host pools with configurable load balancing and assignment types

Enables scheduled agent updates and registration info for session host onboarding

Supports multiple application groups and remote applications for efficient workload publishing

Integrates workspaces with application group associations for user access

Supports scaling plans with host pool association for cost optimization

Utilization of terratest for robust validation

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 5.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 5.12.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [azurerm_virtual_desktop_application.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_application) | resource |
| [azurerm_virtual_desktop_application_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_application_group) | resource |
| [azurerm_virtual_desktop_host_pool.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_host_pool) | resource |
| [azurerm_virtual_desktop_host_pool_registration_info.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_host_pool_registration_info) | resource |
| [azurerm_virtual_desktop_scaling_plan.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_scaling_plan) | resource |
| [azurerm_virtual_desktop_scaling_plan_host_pool_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_scaling_plan_host_pool_association) | resource |
| [azurerm_virtual_desktop_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_workspace) | resource |
| [azurerm_virtual_desktop_workspace_application_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_workspace_application_group_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_host_pool"></a> [host\_pool](#input\_host\_pool) | contains all virtual desktop host pool configuration | <pre>object({<br/>    name                             = string<br/>    resource_group_name              = optional(string)<br/>    location                         = optional(string)<br/>    tags                             = optional(map(string))<br/>    type                             = string<br/>    load_balancer_type               = string<br/>    validate_environment             = optional(bool)<br/>    friendly_name                    = optional(string)<br/>    description                      = optional(string)<br/>    custom_rdp_properties            = optional(string)<br/>    maximum_sessions_allowed         = optional(number)<br/>    personal_desktop_assignment_type = optional(string)<br/>    preferred_app_group_type         = optional(string)<br/>    public_network_access            = optional(string)<br/>    start_vm_on_connect              = optional(bool)<br/>    vm_template                      = optional(string)<br/>    scheduled_agent_updates = optional(object({<br/>      enabled                   = optional(bool)<br/>      timezone                  = optional(string)<br/>      use_session_host_timezone = optional(bool)<br/>      schedule = optional(map(object({<br/>        day_of_week = string<br/>        hour_of_day = number<br/>      })), {})<br/>    }))<br/>    registration_info = optional(object({<br/>      expiration_date = string<br/>    }))<br/>    application_groups = optional(map(object({<br/>      name                         = string<br/>      type                         = string<br/>      resource_group_name          = optional(string)<br/>      location                     = optional(string)<br/>      tags                         = optional(map(string))<br/>      friendly_name                = optional(string)<br/>      description                  = optional(string)<br/>      default_desktop_display_name = optional(string)<br/>      workspace_key                = optional(string)<br/>    })), {})<br/>    applications = optional(map(object({<br/>      name                         = string<br/>      application_group_key        = string<br/>      path                         = string<br/>      command_line_argument_policy = string<br/>      command_line_arguments       = optional(string)<br/>      friendly_name                = optional(string)<br/>      description                  = optional(string)<br/>      icon_path                    = optional(string)<br/>      icon_index                   = optional(number)<br/>      show_in_portal               = optional(bool)<br/>    })), {})<br/>    workspaces = optional(map(object({<br/>      name                          = string<br/>      resource_group_name           = optional(string)<br/>      location                      = optional(string)<br/>      tags                          = optional(map(string))<br/>      friendly_name                 = optional(string)<br/>      description                   = optional(string)<br/>      public_network_access_enabled = optional(bool)<br/>    })), {})<br/>    scaling_plan = optional(object({<br/>      name                = string<br/>      time_zone           = string<br/>      resource_group_name = optional(string)<br/>      location            = optional(string)<br/>      tags                = optional(map(string))<br/>      friendly_name       = optional(string)<br/>      description         = optional(string)<br/>      exclusion_tag       = optional(string)<br/>      enabled             = bool<br/>      schedule = map(object({<br/>        name                                 = string<br/>        days_of_week                         = set(string)<br/>        ramp_up_start_time                   = string<br/>        ramp_up_load_balancing_algorithm     = string<br/>        ramp_up_minimum_hosts_percent        = optional(number)<br/>        ramp_up_capacity_threshold_percent   = optional(number)<br/>        peak_start_time                      = string<br/>        peak_load_balancing_algorithm        = string<br/>        ramp_down_start_time                 = string<br/>        ramp_down_load_balancing_algorithm   = string<br/>        ramp_down_minimum_hosts_percent      = number<br/>        ramp_down_force_logoff_users         = bool<br/>        ramp_down_wait_time_minutes          = number<br/>        ramp_down_notification_message       = string<br/>        ramp_down_capacity_threshold_percent = number<br/>        ramp_down_stop_hosts_when            = string<br/>        off_peak_start_time                  = string<br/>        off_peak_load_balancing_algorithm    = string<br/>      }))<br/>    }))<br/>  })</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | default azure region to be used. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | default resource group to be used. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | tags to be added to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_application_groups"></a> [application\_groups](#output\_application\_groups) | virtual desktop application groups |
| <a name="output_applications"></a> [applications](#output\_applications) | virtual desktop applications |
| <a name="output_host_pool"></a> [host\_pool](#output\_host\_pool) | virtual desktop host pool |
| <a name="output_registration_info"></a> [registration\_info](#output\_registration\_info) | host pool registration info |
| <a name="output_scaling_plan"></a> [scaling\_plan](#output\_scaling\_plan) | virtual desktop scaling plan |
| <a name="output_workspaces"></a> [workspaces](#output\_workspaces) | virtual desktop workspaces |
<!-- END_TF_DOCS -->