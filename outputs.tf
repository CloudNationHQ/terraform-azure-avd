output "host_pool" {
  description = "virtual desktop host pool"
  value       = azurerm_virtual_desktop_host_pool.this
}

output "registration_info" {
  description = "host pool registration info"
  value       = azurerm_virtual_desktop_host_pool_registration_info.this
  sensitive   = true
}

output "application_groups" {
  description = "virtual desktop application groups"
  value       = azurerm_virtual_desktop_application_group.this
}

output "applications" {
  description = "virtual desktop applications"
  value       = azurerm_virtual_desktop_application.this
}

output "workspaces" {
  description = "virtual desktop workspaces"
  value       = azurerm_virtual_desktop_workspace.this
}

output "scaling_plan" {
  description = "virtual desktop scaling plan"
  value       = azurerm_virtual_desktop_scaling_plan.this["this"]
}
