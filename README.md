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

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 5.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (5.12.0)

## Resources

The following resources are used by this module:

- [azurerm_virtual_desktop_application.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_application) (resource)
- [azurerm_virtual_desktop_application_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_application_group) (resource)
- [azurerm_virtual_desktop_host_pool.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_host_pool) (resource)
- [azurerm_virtual_desktop_host_pool_registration_info.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_host_pool_registration_info) (resource)
- [azurerm_virtual_desktop_scaling_plan.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_scaling_plan) (resource)
- [azurerm_virtual_desktop_scaling_plan_host_pool_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_scaling_plan_host_pool_association) (resource)
- [azurerm_virtual_desktop_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_workspace) (resource)
- [azurerm_virtual_desktop_workspace_application_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_workspace_application_group_association) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_host_pool"></a> [host\_pool](#input\_host\_pool)

Description: contains all virtual desktop host pool configuration

Type:

```hcl
object({
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
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_location"></a> [location](#input\_location)

Description: default azure region to be used.

Type: `string`

Default: `null`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: default resource group to be used.

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: tags to be added to the resources

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_application_groups"></a> [application\_groups](#output\_application\_groups)

Description: virtual desktop application groups

### <a name="output_applications"></a> [applications](#output\_applications)

Description: virtual desktop applications

### <a name="output_host_pool"></a> [host\_pool](#output\_host\_pool)

Description: virtual desktop host pool

### <a name="output_registration_info"></a> [registration\_info](#output\_registration\_info)

Description: host pool registration info

### <a name="output_scaling_plan"></a> [scaling\_plan](#output\_scaling\_plan)

Description: virtual desktop scaling plan

### <a name="output_workspaces"></a> [workspaces](#output\_workspaces)

Description: virtual desktop workspaces
<!-- END_TF_DOCS -->
## Goals

For more information, please see our [goals and non-goals](./GOALS.md).

## Testing

For more information, please see our testing [guidelines](./TESTING.md)

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

To update the module's documentation run `make docs`

## Authors

Module is maintained by [these awesome contributors](https://github.com/cloudnationhq/terraform-azure-avd/graphs/contributors).

## Contributors

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md).

## License

MIT Licensed. See [LICENSE](https://github.com/cloudnationhq/terraform-azure-avd/blob/main/LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/virtual-desktop/)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/desktopvirtualization/)
