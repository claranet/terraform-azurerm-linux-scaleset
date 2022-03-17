# Azure Linux ScaleSet
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/linux-scaleset/azurerm/)

Azure terraform module to create an [Azure Linux ScaleSet](https://azure.microsoft.com/en-us/services/virtual-machine-scale-sets/).

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 5.x.x       | 0.15.x & 1.0.x    | >= 2.0          |
| >= 4.x.x       | 0.13.x            | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "vnet" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  environment    = var.environment
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name
  vnet_cidr           = ["10.0.1.0/24"]
}


module "subnet" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  environment    = var.environment
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  stack          = var.stack

  resource_group_name  = module.rg.resource_group_name
  virtual_network_name = module.vnet.virtual_network_name
  subnet_cidr_list     = ["10.0.1.0/26"]
}


module "logs" {
  source  = "claranet/run-common/azurerm//modules/logs"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name
}

module "az_monitor" {
  source  = "claranet/run-iaas/azurerm//modules/vm-monitoring"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name        = module.rg.resource_group_name
  log_analytics_workspace_id = module.logs.log_analytics_workspace_id

  extra_tags = {
    foo = "bar"
  }
}

module "linux_scaleset" {
  source  = "claranet/linux-scaleset/azurerm"
  version = "x.x.x"

  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack
  location       = module.azure_region.location
  location_short = module.azure_region.location_short

  resource_group_name = module.rg.resource_group_name

  admin_username = "myusername"
  ssh_public_key = var.ssh_public_key

  vms_sku = "Standard_B2s"

  subnet_id = module.subnet.subnet_id

  source_image_reference = {
    publisher = "Debian"
    offer     = "debian-10"
    sku       = "10"
    version   = "latest"
  }

  azure_monitor_data_collection_rule_id = module.az_monitor.data_collection_rule_id
  log_analytics_workspace_guid          = module.logs.log_analytics_workspace_guid
  log_analytics_workspace_key           = module.logs.log_analytics_workspace_primary_key
}

```

## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.1 |
| azurerm | >= 2.37.0 |
| null | >= 3.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurecaf_name.ipconfig](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.nic](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.vmss_linux](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurerm_linux_virtual_machine_scale_set.linux_vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set) | resource |
| [azurerm_virtual_machine_scale_set_extension.azure_monitor_agent](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_scale_set_extension) | resource |
| [azurerm_virtual_machine_scale_set_extension.log_extension](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_scale_set_extension) | resource |
| [null_resource.azure_monitor_link](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| accelerated\_networking | Specifies whether to enable accelerated networking or not | `bool` | `false` | no |
| admin\_password | Password for the administrator account of the virtual machine. | `string` | `null` | no |
| admin\_username | Username to use as admin user | `string` | n/a | yes |
| application\_gateway\_backend\_address\_pool\_ids | Specifies an array of references to backend address pools of application gateways. A scale set can reference backend address pools of one application gateway | `list(string)` | `[]` | no |
| application\_security\_group\_ids | Specifies up to 20 application security group IDs | `list(string)` | `[]` | no |
| automatic\_instance\_repair | Enable automatic instance repair. Must have health\_probe\_id or an Application Health Extension | `bool` | `false` | no |
| automatic\_os\_upgrade | Automatic OS patches can be applied by Azure to your scaleset. This is particularly useful when upgrade\_policy\_mode is set to Rolling. | `bool` | `false` | no |
| azure\_monitor\_agent\_version | Azure Monitor Agent extension version | `string` | `"1.12"` | no |
| azure\_monitor\_data\_collection\_rule\_id | Data Collection Rule ID from Azure Monitor for metrics and logs collection | `string` | n/a | yes |
| boot\_diagnostics\_storage\_uri | Blob endpoint for the storage account to hold the virtual machine's diagnostic files | `string` | `""` | no |
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| custom\_data | The Base64-Encoded Custom Data which should be used for this Virtual Machine Scale Set. | `string` | `null` | no |
| custom\_ipconfig\_name | Custom name for Ipconfiguration | `string` | `null` | no |
| custom\_nic\_name | Custom name for Network Interfaces | `string` | `null` | no |
| custom\_vmss\_name | Custom name for the Virtual Machine ScaleSet | `string` | `null` | no |
| data\_disks | A storage profile data disk | `list(any)` | `[]` | no |
| disable\_automatic\_rollback | Disable automatic rollback in case of failured | `bool` | `false` | no |
| dns\_servers | Specifies an array of DNS servers | `list(string)` | `[]` | no |
| environment | Project environment | `string` | n/a | yes |
| extensions | Can be specified to add extension profiles to the scale set | `map(any)` | `{}` | no |
| extra\_tags | Additional tags to associate with your scale set. | `map(string)` | `{}` | no |
| health\_probe\_id | Specifies the identifier for the load balancer health probe. Required when using Rolling as your upgrade\_policy\_mode. | `string` | `null` | no |
| identity | Map with identity block informations as described here https://www.terraform.io/docs/providers/azurerm/r/linux_virtual_machine_scale_set.html#identity | <pre>object({<br>    type         = string<br>    identity_ids = list(string)<br>  })</pre> | `null` | no |
| instances\_count | Specify the number of instances to run | `number` | `1` | no |
| ip\_forwarding | Whether IP forwarding is enabled on this NIC | `bool` | `false` | no |
| load\_balancer\_backend\_address\_pool\_ids | Specifies an array of references to backend address pools of load balancers. A scale set can reference backend address pools of one public and one internal load balancer | `list(string)` | `[]` | no |
| load\_balancer\_inbound\_nat\_rules\_ids | Specifies an array of references to inbound NAT rules for load balancers | `list(string)` | `[]` | no |
| location | Azure region to use | `string` | n/a | yes |
| location\_short | Short string for Azure location | `string` | n/a | yes |
| log\_analytics\_agent\_enabled | Deploy Log Analytics VM extension - depending of OS (cf. https://docs.microsoft.com/fr-fr/azure/azure-monitor/agents/agents-overview#linux) | `bool` | `true` | no |
| log\_analytics\_agent\_version | Azure Log Analytics extension version | `string` | `"1.13"` | no |
| log\_analytics\_workspace\_guid | GUID of the Log Analytics Workspace to link with | `string` | `null` | no |
| log\_analytics\_workspace\_key | Access key of the Log Analytics Workspace to link with | `string` | `null` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name | `string` | `""` | no |
| network\_security\_group\_id | Specifies the id for the network security group | `string` | `""` | no |
| os\_disk\_caching | Specifies the caching requirements [Possible values : None, ReadOnly, ReadWrite] | `string` | `"None"` | no |
| os\_disk\_encryption\_set\_id | The ID of the Disk Encryption Set which should be used to encrypt this Data Disk | `string` | `null` | no |
| os\_disk\_is\_local | Specifies the Ephemeral Disk Settings for the OS Disk to Local | `bool` | `false` | no |
| os\_disk\_managed\_disk\_type | Specifies the type of managed disk to create [Possible values : Standard\_LRS, StandardSSD\_LRS or Premium\_LRS] | `string` | `"Standard_LRS"` | no |
| os\_disk\_size\_gb | Size of the OS disk in GB | `number` | `32` | no |
| os\_disk\_write\_accelerator\_enabled | True to enable Write Accelerator for this Data Disk | `bool` | `false` | no |
| overprovision | Should Azure over-provision Virtual Machines in this Scale Set? This means that multiple Virtual Machines will be provisioned and Azure will keep the instances which become available first - which improves provisioning success rates and improves deployment time. | `bool` | `true` | no |
| resource\_group\_name | Name of the resource group | `string` | n/a | yes |
| rolling\_upgrade\_policy | This is only applicable when the upgrade\_policy\_mode is Rolling. | <pre>object({<br>    max_batch_instance_percent              = number<br>    max_unhealthy_instance_percent          = number<br>    max_unhealthy_upgraded_instance_percent = number<br>    pause_time_between_batches              = string<br>  })</pre> | <pre>{<br>  "max_batch_instance_percent": 25,<br>  "max_unhealthy_instance_percent": 25,<br>  "max_unhealthy_upgraded_instance_percent": 25,<br>  "pause_time_between_batches": "PT30S"<br>}</pre> | no |
| scale\_in\_policy | The scale-in policy rule that decides which virtual machines are chosen for removal when a Virtual Machine Scale Set is scaled in. Possible values for the scale-in policy rules are Default, NewestVM and OldestVM, defaults to Default | `string` | `"Default"` | no |
| source\_image\_id | Id of the image to use. | `string` | `null` | no |
| source\_image\_reference | Source Image references | <pre>object({<br>    publisher = string<br>    offer     = string<br>    sku       = string<br>    version   = string<br>  })</pre> | `null` | no |
| ssh\_public\_key | Path to the public SSH key deployed on Scale set | `string` | `null` | no |
| stack | Project stack name | `string` | n/a | yes |
| subnet\_id | Specifies the identifier of the subnet | `string` | n/a | yes |
| ultra\_ssd\_enabled | Should the capacity to enable Data Disks of the UltraSSD\_LRS storage account type be supported on this Virtual Machine Scale Set? | `bool` | `false` | no |
| upgrade\_mode | Specifies how Upgrades (e.g. changing the Image/SKU) should be performed to Virtual Machine Instances. Possible values are Automatic, Manual and Rolling. Defaults to Manual. | `string` | `"Manual"` | no |
| use\_caf\_naming | Use the Azure CAF naming provider to generate default resource name. `custom_vmss_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| vms\_sku | Specifies the size of virtual machines in a scale set | `string` | n/a | yes |
| zone\_balance | Should the Virtual Machines in this Scale Set be strictly evenly distributed across Availability Zones? Changing this forces a new resource to be created. | `bool` | `true` | no |
| zones\_list | A list of Availability Zones in which the Virtual Machines in this Scale Set should be created in. Changing this forces a new resource to be created. | `list(number)` | <pre>[<br>  1,<br>  2,<br>  3<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| scale\_set\_id | Scale Set ID |
| scale\_set\_name | Scale Set Name |
| system\_assigned\_identity | Identity block with principal ID |
<!-- END_TF_DOCS -->
## Related documentation

- Microsoft Azure documentation: [docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/) 
