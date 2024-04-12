# Azure Linux ScaleSet
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/linux-scaleset/azurerm/)

Azure terraform module to create an [Azure Linux ScaleSet](https://azure.microsoft.com/en-us/services/virtual-machine-scale-sets/).

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 7.x.x       | 1.3.x             | >= 3.0          |
| >= 6.x.x       | 1.x               | >= 3.0          |
| >= 5.x.x       | 0.15.x            | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Contributing

If you want to contribute to this repository, feel free to use our [pre-commit](https://pre-commit.com/) git hook configuration
which will help you automatically update and format some files for you by enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

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

module "run" {
  source  = "claranet/run/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name

  monitoring_function_enabled = false
  vm_monitoring_enabled       = true
  backup_vm_enabled           = false
  update_center_enabled       = false
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

  vms_size = "Standard_D2d_v5"

  subnet_id = module.subnet.subnet_id

  # The feature must be activated upstream:
  # az feature register --namespace Microsoft.Compute --name EncryptionAtHost --subscription <subscription_id_or_name>
  encryption_at_host_enabled = true

  source_image_reference = {
    publisher = "Debian"
    offer     = "debian-10"
    sku       = "10"
    version   = "latest"
  }

  azure_monitor_data_collection_rule_id = module.run.data_collection_rule_id
}
```

## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.2, >= 1.2.22 |
| azurerm | ~> 3.24 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine_scale_set.linux_vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set) | resource |
| [azurerm_monitor_data_collection_rule_association.dcr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule_association) | resource |
| [azurerm_virtual_machine_scale_set_extension.azure_monitor_agent](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_scale_set_extension) | resource |
| [azurerm_virtual_machine_scale_set_extension.extension](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_scale_set_extension) | resource |
| [azurecaf_name.ipconfig](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.nic](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.vmss_linux](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| accelerated\_networking | Whether to enable accelerated networking or not. | `bool` | `true` | no |
| admin\_password | Password for the administrator account of the Virtual Machines. | `string` | `null` | no |
| admin\_username | Username of the administrator account of the Virtual Machines. | `string` | n/a | yes |
| application\_gateway\_backend\_address\_pool\_ids | List of references to backend address pools of Application Gateways. A Scale Set can reference backend address pools of one Application Gateway. | `list(string)` | `[]` | no |
| application\_security\_group\_ids | IDs of Application Security Group IDs (up to 20). | `list(string)` | `[]` | no |
| automatic\_instance\_repair | Whether to enable automatic instance repair. Must have health\_probe\_id or an Application Health Extension. | `bool` | `false` | no |
| automatic\_os\_upgrade | Whether if automatic OS patches can be applied by Azure to your Scale Set. This is particularly useful when upgrade\_policy\_mode is set to Rolling. | `bool` | `false` | no |
| azure\_monitor\_agent\_enabled | Whether to enable Azure Monitor Agent. Requires a Data Collection Rule ID. | `bool` | `true` | no |
| azure\_monitor\_agent\_version | Azure Monitor Agent extension version. | `string` | `"1.22"` | no |
| azure\_monitor\_data\_collection\_rule\_id | Data Collection Rule ID from Azure Monitor for metrics and logs collection. | `string` | `""` | no |
| boot\_diagnostics\_storage\_uri | Blob endpoint for the Storage Account to hold the Virtual Machines diagnostic files. | `string` | `""` | no |
| client\_name | Client name/account used in naming. | `string` | n/a | yes |
| custom\_data | The Base64-Encoded Custom Data which should be used for this Virtual Machine Scale Set. | `string` | `null` | no |
| custom\_dcr\_name | Custom name for Data collection rule association. | `string` | `null` | no |
| custom\_ipconfig\_name | Custom name for Ipconfiguration. | `string` | `null` | no |
| custom\_nic\_name | Custom name for Network Interfaces. | `string` | `null` | no |
| custom\_vmss\_name | Custom name for the Virtual Machine ScaleSet. | `string` | `null` | no |
| data\_disks | Data disks profiles to attach. | <pre>list(object({<br>    name                      = string<br>    lun                       = number<br>    disk_size_gb              = optional(number, null)<br>    create_option             = optional(string, "Empty")<br>    caching                   = optional(string, "None")<br>    storage_account_type      = optional(string, "StandardSSD_LRS")<br>    disk_encryption_set_id    = optional(string, null)<br>    disk_iops_read_write      = optional(string, null)<br>    disk_mbps_read_write      = optional(string, null)<br>    write_accelerator_enabled = optional(string, null)<br>  }))</pre> | `[]` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| disable\_automatic\_rollback | Disable automatic rollback in case of failures. | `bool` | `false` | no |
| dns\_servers | List of DNS servers. | `list(string)` | `[]` | no |
| encryption\_at\_host\_enabled | Should all disks (including the temporary disk) attached to Virtual Machines in a Scale Set be encrypted by enabling Encryption at Host? List of compatible VM sizes: https://learn.microsoft.com/en-us/azure/virtual-machines/linux/disks-enable-host-based-encryption-cli#finding-supported-vm-sizes. | `bool` | `false` | no |
| environment | Project environment. | `string` | n/a | yes |
| extensions | Extensions to add to the Scale Set. | <pre>list(object({<br>    name                        = string<br>    publisher                   = string<br>    type                        = string<br>    type_handler_version        = string<br>    auto_upgrade_minor_version  = optional(bool, true)<br>    automatic_upgrade_enabled   = optional(bool, false)<br>    failure_suppression_enabled = optional(bool, false)<br>    force_update_tag            = optional(string, null)<br>    protected_settings          = optional(string, null)<br>    provision_after_extensions  = optional(list(string), [])<br>    settings                    = optional(string, null)<br>  }))</pre> | `[]` | no |
| extra\_tags | Additional tags to associate with your scale set. | `map(string)` | `{}` | no |
| health\_probe\_id | Specifies the identifier for the Load Balancer health probe. Required when using Rolling as your upgrade\_policy\_mode. | `string` | `null` | no |
| identity | Identity block information as described here https://www.terraform.io/docs/providers/azurerm/r/linux_virtual_machine_scale_set.html#identity. | <pre>object({<br>    type         = string<br>    identity_ids = list(string)<br>  })</pre> | `null` | no |
| instances\_count | Number of instances in the Scale Set. | `number` | `2` | no |
| ip\_forwarding\_enabled | Whether IP forwarding is enabled on this NIC. | `bool` | `false` | no |
| load\_balancer\_backend\_address\_pool\_ids | List of references to backend address pools of Load Balancers. A Scale Set can reference backend address pools of one public and one internal Load Balancer. | `list(string)` | `[]` | no |
| load\_balancer\_inbound\_nat\_rules\_ids | List of references to inbound NAT rules for Load Balancers. | `list(string)` | `[]` | no |
| location | Azure region to use. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| name\_prefix | Optional prefix for the generated name. | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name. | `string` | `""` | no |
| network\_security\_group\_id | ID of the Network Security Group. | `string` | `null` | no |
| os\_disk\_caching | OS disk caching requirements [Possible values : None, ReadOnly, ReadWrite]. | `string` | `"None"` | no |
| os\_disk\_encryption\_set\_id | ID of the Disk Encryption Set which should be used to encrypt the OS disk. | `string` | `null` | no |
| os\_disk\_managed\_disk\_type | Type of managed disk to create [Possible values : Standard\_LRS, StandardSSD\_LRS or Premium\_LRS]. | `string` | `"StandardSSD_LRS"` | no |
| os\_disk\_size\_gb | Size of the OS disk in GB. | `number` | `32` | no |
| os\_disk\_write\_accelerator\_enabled | Whether to enable write accelerator for the OS disk. | `bool` | `false` | no |
| os\_ephemeral\_disk\_enabled | Whether OS disk is local ephemeral disk. See https://learn.microsoft.com/en-us/azure/virtual-machines/ephemeral-os-disks. | `bool` | `true` | no |
| os\_ephemeral\_disk\_placement | Placement for the local ephemeral disk. Value can be `CacheDisk` or `ResourceDisk`. See https://learn.microsoft.com/en-us/azure/virtual-machines/ephemeral-os-disks. | `string` | `"ResourceDisk"` | no |
| overprovision | Should Azure over-provision Virtual Machines in this Scale Set? This means that multiple Virtual Machines will be provisioned and Azure will keep the instances which become available first - which improves provisioning success rates and improves deployment time. | `bool` | `true` | no |
| resource\_group\_name | Name of the resource group. | `string` | n/a | yes |
| rolling\_upgrade\_policy | Rolling upgrade policy, only applicable when the upgrade\_policy\_mode is Rolling. | <pre>object({<br>    max_batch_instance_percent              = number<br>    max_unhealthy_instance_percent          = number<br>    max_unhealthy_upgraded_instance_percent = number<br>    pause_time_between_batches              = string<br>  })</pre> | <pre>{<br>  "max_batch_instance_percent": 25,<br>  "max_unhealthy_instance_percent": 25,<br>  "max_unhealthy_upgraded_instance_percent": 25,<br>  "pause_time_between_batches": "PT30S"<br>}</pre> | no |
| scale\_in\_force\_deletion | Whether the Virtual Machines chosen for removal should be force deleted when the Virtual Machine Scale Set is being scaled-in. | `bool` | `false` | no |
| scale\_in\_policy | The scale-in policy rule that decides which Virtual Machines are chosen for removal when a Virtual Machine Scale Set is scaled in. Possible values for the scale-in policy rules are Default, NewestVM and OldestVM, defaults to Default. | `string` | `"Default"` | no |
| source\_image\_id | ID of the Virtual Machines image to use. | `string` | `null` | no |
| source\_image\_reference | Virtual Machines source image reference. | <pre>object({<br>    publisher = string<br>    offer     = string<br>    sku       = string<br>    version   = string<br>  })</pre> | `null` | no |
| ssh\_private\_key | Private SSH key deployed on Scale set. | `string` | `null` | no |
| ssh\_public\_key | Public SSH key deployed on Scale set. | `string` | `null` | no |
| stack | Project stack name. | `string` | n/a | yes |
| subnet\_id | ID of the subnet. | `string` | n/a | yes |
| ultra\_ssd\_enabled | Whether UltraSSD\_LRS storage account type can be enabled. | `bool` | `false` | no |
| upgrade\_mode | Specifies how Upgrades (e.g. changing the Image/SKU) should be performed to Virtual Machine Instances. Possible values are Automatic, Manual and Rolling. Defaults to Manual. | `string` | `"Manual"` | no |
| use\_caf\_naming | Use the Azure CAF naming provider to generate default resource name. `custom_vmss_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| user\_data | The Base64-Encoded User Data which should be used for this Virtual Machine Scale Set. | `string` | `null` | no |
| vms\_size | Size (SKU) of Virtual Machines in a Scale Set. | `string` | n/a | yes |
| zone\_balancing\_enabled | Whether the Virtual Machines in this Scale Set should be strictly evenly distributed across Availability Zones? Changing this forces a new resource to be created. | `bool` | `true` | no |
| zones\_list | A list of Availability Zones in which the Virtual Machines in this Scale Set should be created in. Changing this forces a new resource to be created. | `list(number)` | <pre>[<br>  1,<br>  2,<br>  3<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| scale\_set\_admin\_password | Scale Set admin password |
| scale\_set\_admin\_ssh\_private\_key | Scale Set admin SSH private key |
| scale\_set\_admin\_ssh\_public\_key | Scale Set admin SSH public key |
| scale\_set\_admin\_username | Scale Set admin username |
| scale\_set\_id | Scale Set ID |
| scale\_set\_name | Scale Set Name |
| system\_assigned\_identity | Identity block with principal ID |
| terraform\_module | Information about this Terraform module |
<!-- END_TF_DOCS -->

## Related documentation

- Microsoft Azure documentation: [docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/)
