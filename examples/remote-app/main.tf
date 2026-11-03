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
    preferred_app_group_type = "RailApplications"

    workspaces = {
      demo = {
        name          = module.naming.virtual_desktop_workspace.name_unique
        friendly_name = "Demo workspace"
      }
    }

    application_groups = {
      apps = {
        name          = module.naming.virtual_desktop_application_group.name_unique
        type          = "RemoteApp"
        workspace_key = "demo"
      }
    }

    applications = {
      notepad = {
        name                         = "notepad"
        application_group_key        = "apps"
        friendly_name                = "Notepad"
        path                         = "C:\\Windows\\System32\\notepad.exe"
        command_line_argument_policy = "DoNotAllow"
        show_in_portal               = true
        icon_path                    = "C:\\Windows\\System32\\notepad.exe"
        icon_index                   = 0
      }
      calc = {
        name                         = "calculator"
        application_group_key        = "apps"
        friendly_name                = "Calculator"
        path                         = "C:\\Windows\\System32\\calc.exe"
        command_line_argument_policy = "Allow"
        command_line_arguments       = "--demo"
      }
    }
  }
}
