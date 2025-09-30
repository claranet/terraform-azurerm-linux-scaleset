# Azure Linux ScaleSet
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-blue.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![OpenTofu Registry](https://img.shields.io/badge/opentofu-registry-yellow.svg)](https://search.opentofu.org/module/claranet/linux-scaleset/azurerm/)

Azure terraform module to create an [Azure Linux Virtual Machine Scale Set](https://azure.microsoft.com/en-us/services/virtual-machine-scale-sets/).

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | OpenTofu version | AzureRM version |
| -------------- | ----------------- | ---------------- | --------------- |
| >= 8.x.x       | **Unverified**    | 1.8.x            | >= 4.0          |
| >= 7.x.x       | 1.3.x             |                  | >= 3.0          |
| >= 6.x.x       | 1.x               |                  | >= 3.0          |
| >= 5.x.x       | 0.15.x            |                  | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   |                  | >= 2.0          |
| >= 3.x.x       | 0.12.x            |                  | >= 2.0          |
| >= 2.x.x       | 0.12.x            |                  | < 2.0           |
| <  2.x.x       | 0.11.x            |                  | < 2.0           |

## Contributing

If you want to contribute to this repository, feel free to use our [pre-commit](https://pre-commit.com/) git hook configuration
which will help you automatically update and format some files for you by enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

⚠️ Since modules version v8.0.0, we do not maintain/check anymore the compatibility with
[Hashicorp Terraform](https://github.com/hashicorp/terraform/). Instead, we recommend to use [OpenTofu](https://github.com/opentofu/opentofu/).

```hcl
module "linux_scaleset" {
  source  = "claranet/linux-scaleset/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  vm_size        = "Standard_F4s_v2"
  admin_username = "myusername"

  subnet = module.subnet

  ssh_public_key = var.ssh_public_key

  ultra_ssd_enabled = true

  # Value depends on `var.vm_size` local storage size
  os_disk_size_gb = 31

  data_disks = [
    {
      lun                  = 0
      disk_size_gb         = 32
      caching              = "ReadOnly"
      storage_account_type = "Premium_LRS"
    },
    {
      lun                  = 1
      disk_size_gb         = 48
      disk_iops_read_write = 4000
      storage_account_type = "UltraSSD_LRS"
    },
  ]

  # The feature must be activated upstream:
  # az feature register --namespace Microsoft.Compute --name EncryptionAtHost --subscription <subscription_id_or_name>
  encryption_at_host_enabled = true

  source_image_reference = {
    publisher = "Debian"
    offer     = "debian-11"
    sku       = "11-gen2"
    version   = "latest"
  }

  upgrade_mode = "Automatic"
  automatic_instance_repair = {
    enabled = true
  }

  load_balancer_backend_address_pool_ids = var.lb_backend_address_pool_id[*]
  health_probe = {
    id = var.health_probe_id
  }

  diagnostics_storage_account_name = module.run.logs_storage_account_name
  azure_monitor_data_collection_rule = {
    id = module.run.data_collection_rule_id
  }

  extra_tags = {
    "extra-tag" = "extra-tag-value"
  }
}
```

## Providers

| Name | Version |
|------|---------|
| azurecaf | >= 1.2.28 |
| azurerm | ~> 4.31 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine_scale_set.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set) | resource |
| [azurerm_monitor_data_collection_rule_association.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule_association) | resource |
| [azurerm_virtual_machine_scale_set_extension.azure_monitor_agent](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_scale_set_extension) | resource |
| [azurerm_virtual_machine_scale_set_extension.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_scale_set_extension) | resource |
| [azurecaf_name.ip_configuration](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.nic](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.vmss_linux](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| accelerated\_networking\_enabled | Should accelerated networking be enabled? Defaults to `true`. | `bool` | `true` | no |
| admin\_password | Password for the Scale Set administrator account. One of either `var.admin_password` or `var.ssh_public_key` must be specified. Changing this forces a new resource to be created. | `string` | `null` | no |
| admin\_username | Username of the Scale Set administrator account. | `string` | n/a | yes |
| application\_gateway\_backend\_address\_pool\_ids | List of references to backend address pools of an Application Gateway. A Scale Set can reference backend address pools of a single Application Gateway. | `list(string)` | `null` | no |
| application\_security\_group\_ids | IDs of Application Security Groups (up to 20). | `list(string)` | `null` | no |
| automatic\_instance\_repair | Whether to enable automatic instance repair. Must have a valid `var.health_probe.id` or an [Application Health Extension](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-health-extension?tabs=rest-api). | <pre>object({<br/>    enabled      = optional(bool, false)<br/>    grace_period = optional(string, "PT10M")<br/>    action       = optional(string, "Replace")<br/>  })</pre> | `{}` | no |
| automatic\_os\_upgrade\_enabled | Should OS upgrades automatically be applied to Scale Set instances in a rolling fashion when a newer version of the OS image becomes available? This is particularly useful when `var.upgrade_mode = "Rolling"`. Defaults to `false`. | `bool` | `false` | no |
| automatic\_rollback\_enabled | Should automatic rollbacks be enabled? Only available when `var.upgrade_mode` is not 'Manual'. Defaults to `true`. | `bool` | `true` | no |
| azure\_monitor\_agent\_enabled | Whether to enable Azure Monitor Agent. Requires a Data Collection Rule ID. | `bool` | `true` | no |
| azure\_monitor\_agent\_version | Azure Monitor Agent extension version. | `string` | `"1.22"` | no |
| azure\_monitor\_data\_collection\_rule | Data Collection Rule ID from Azure Monitor for metrics and logs collection. | <pre>object({<br/>    id = string<br/>  })</pre> | `null` | no |
| client\_name | Client name/account used in naming. | `string` | n/a | yes |
| custom\_data | The Base64-Encoded Custom Data which should be used for this Virtual Machine Scale Set. | `string` | `null` | no |
| custom\_name | Custom name for the Virtual Machine Scale Sets. Generated if not set. | `string` | `null` | no |
| data\_disks | Definition of data disks to be attached to instances in the Scale Set. | <pre>list(object({<br/>    # name                    = string (unexpected status 400 (400 Bad Request) with error: InvalidParameter: Parameter 'dataDisk.name' is not allowed.)<br/>    lun                       = number<br/>    disk_size_gb              = number<br/>    create_option             = optional(string, "Empty")<br/>    caching                   = optional(string, "None")<br/>    storage_account_type      = optional(string, "StandardSSD_LRS")<br/>    disk_encryption_set_id    = optional(string)<br/>    disk_iops_read_write      = optional(string)<br/>    disk_mbps_read_write      = optional(string)<br/>    write_accelerator_enabled = optional(bool, false)<br/>  }))</pre> | `[]` | no |
| dcr\_custom\_name | Custom name for the Data Collection Rule association. | `string` | `null` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| diagnostics\_storage\_account\_name | Name of the Storage Account in which Scale Set boot diagnostics are stored. | `string` | `null` | no |
| dns\_servers | List of DNS servers. | `list(string)` | `null` | no |
| encryption\_at\_host\_enabled | Should all disks (including the temporary disk) attached to instances in the Scale Set be encrypted by enabling Encryption at Host? See [documentation](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/disks-enable-host-based-encryption-cli#finding-supported-vm-sizes) for list of compatible VM sizes. Defaults to `true`. | `bool` | `true` | no |
| environment | Project environment. | `string` | n/a | yes |
| extensions | Extensions to add to the Scale Set. | <pre>list(object({<br/>    name                        = string<br/>    publisher                   = string<br/>    type                        = string<br/>    type_handler_version        = string<br/>    auto_upgrade_minor_version  = optional(bool, true)<br/>    automatic_upgrade_enabled   = optional(bool, false)<br/>    failure_suppression_enabled = optional(bool, false)<br/>    force_update_tag            = optional(string)<br/>    protected_settings          = optional(string)<br/>    provision_after_extensions  = optional(list(string))<br/>    settings                    = optional(string)<br/>  }))</pre> | `[]` | no |
| extra\_tags | Additional tags to associate with the Scale Set. | `map(string)` | `{}` | no |
| health\_probe | Specifies the identifier for the Load Balancer health probe. Required when `var.upgrade_mode = "Automatic" or "Rolling"`. | <pre>object({<br/>    id = string<br/>  })</pre> | `null` | no |
| identity | Identity block information as described in this [documentation](https://www.terraform.io/docs/providers/azurerm/r/linux_virtual_machine_scale_set.html#identity). | <pre>object({<br/>    type         = optional(string, "SystemAssigned")<br/>    identity_ids = optional(list(string))<br/>  })</pre> | `{}` | no |
| instance\_count | Number of instances in the Scale Set. Defaults to `2`. | `number` | `2` | no |
| ip\_configuration\_custom\_name | Custom name for the IP configuration of the network interfaces. Generated if not set. | `string` | `null` | no |
| ip\_forwarding\_enabled | Does this network interface support IP forwarding? Defaults to `false`. | `bool` | `false` | no |
| load\_balancer\_backend\_address\_pool\_ids | List of references to backend address pools of Load Balancers. A Scale Set can reference backend address pools of one public and one internal Load Balancer. | `list(string)` | `null` | no |
| load\_balancer\_inbound\_nat\_rules\_ids | List of references to inbound NAT rules for Load Balancers. | `list(string)` | `null` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| name\_prefix | Optional prefix for the generated name. | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name. | `string` | `""` | no |
| network\_security\_group | ID of the Network Security Group to be assigned to this network interface. | <pre>object({<br/>    id = string<br/>  })</pre> | `null` | no |
| nic\_custom\_name | Custom name for the network interfaces. Generated if not set. | `string` | `null` | no |
| os\_disk\_caching | OS disk caching requirements. Possible values are `None`, `ReadOnly` and `ReadWrite`. Defaults to `None`. | `string` | `"None"` | no |
| os\_disk\_encryption\_set\_id | ID of the Disk Encryption Set which should be used to encrypt the OS disk. Changing this forces a new resource to be created. | `string` | `null` | no |
| os\_disk\_managed\_disk\_type | Type of managed disk to create. Possible values are `Standard_LRS`, `StandardSSD_LRS`, `Premium_LRS`, `StandardSSD_ZRS` and `Premium_ZRS`. Defaults to `StandardSSD_LRS`. | `string` | `"StandardSSD_LRS"` | no |
| os\_disk\_size\_gb | Size of the OS disk in GB. | `number` | `32` | no |
| os\_disk\_write\_accelerator\_enabled | Whether to enable write accelerator for the OS disk. | `bool` | `false` | no |
| os\_ephemeral\_disk\_enabled | Whether OS disk is local ephemeral disk. See [documentation](https://learn.microsoft.com/en-us/azure/virtual-machines/ephemeral-os-disks). Changing this forces a new resource to be created. | `bool` | `true` | no |
| os\_ephemeral\_disk\_placement | Placement for the local ephemeral disk. Possibles values are `CacheDisk` and `ResourceDisk`. See [documentation](https://learn.microsoft.com/en-us/azure/virtual-machines/ephemeral-os-disks). Defaults to `ResourceDisk`. Changing this forces a new resource to be created. | `string` | `"ResourceDisk"` | no |
| overprovisioning\_enabled | Should Azure overprovision instances in this Scale Set? This means that multiple Virtual Machines will be provisioned and Azure will keep the instances which become available first, which improves provisioning success rates and improves deployment time. Defaults to `true`. | `bool` | `true` | no |
| resource\_group\_name | Resource Group name. | `string` | n/a | yes |
| rolling\_upgrade\_policy | Rolling upgrade policy. Only applicable when `var.upgrade_mode` is not 'Manual'. | <pre>object({<br/>    cross_zone_upgrades_enabled             = optional(bool)<br/>    max_batch_instance_percent              = optional(number, 25)<br/>    max_unhealthy_instance_percent          = optional(number, 25)<br/>    max_unhealthy_upgraded_instance_percent = optional(number, 25)<br/>    pause_time_between_batches              = optional(string, "PT30S")<br/>    prioritize_unhealthy_instances_enabled  = optional(bool)<br/>    maximum_surge_instances_enabled         = optional(bool)<br/>  })</pre> | `{}` | no |
| scale\_in\_force\_deletion\_enabled | Whether the instances chosen for removal should be force deleted when the Virtual Machine Scale Set is being scaled-in. | `bool` | `false` | no |
| scale\_in\_policy | The scale-in policy rule that decides which instances are chosen for removal when a Virtual Machine Scale Set is scaled-in. Possible values are `Default`, `NewestVM` and `OldestVM`. Defaults to `Default`. | `string` | `"Default"` | no |
| source\_image\_id | ID of the source image to use. One of either `var.source_image_id` or `var.source_image_reference` must be specified. Changing this forces a new resource to be created. | `string` | `null` | no |
| source\_image\_reference | Reference of the source image to use. One of either `var.source_image_id` or `var.source_image_reference` must be specified. Changing this forces a new resource to be created. | <pre>object({<br/>    publisher = string<br/>    offer     = string<br/>    sku       = string<br/>    version   = string<br/>  })</pre> | `null` | no |
| ssh\_private\_key | Private SSH key to be deployed on instances in the Scale set. | `string` | `null` | no |
| ssh\_public\_key | Public SSH key to be deployed on instances in the Scale set. One of either `var.admin_password` or `var.ssh_public_key` must be specified. Changing this forces a new resource to be created. | `string` | `null` | no |
| stack | Project Stack name. | `string` | n/a | yes |
| subnet | ID of the Subnet. | <pre>object({<br/>    id = string<br/>  })</pre> | n/a | yes |
| ultra\_ssd\_enabled | Should the capacity to use `UltraSSD_LRS` Storage Account type be supported on this Scale Set?. Defaults to `false`. Changing this forces a new resource to be created. | `bool` | `false` | no |
| upgrade\_mode | Specifies how upgrades (e.g. changing the image/SKU) should be performed to instances in the Scale Set. Possible values are `Automatic`, `Manual` and `Rolling`. Defaults to `Manual`. Changing this forces a new resource to be created. | `string` | `"Manual"` | no |
| user\_data | The Base64-Encoded User Data which should be used for this Virtual Machine Scale Set. | `string` | `null` | no |
| vm\_size | Size (SKU) of instances in the Scale Set. | `string` | n/a | yes |
| vtpm\_enabled | Specifies if vTPM (virtual Trusted Platform Module) and Trusted Launch is enabled for the Scale Set. Defaults to `true`. Changing this forces a new resource to be created. | `bool` | `true` | no |
| zone\_balancing\_enabled | Whether the instances in this Scale Set should be strictly evenly distributed across Availability Zones? Changing this forces a new resource to be created. | `bool` | `true` | no |
| zones | A list of Availability Zones in which the instances in this Scale Set should be created in. Updating zones to remove an existing zone forces a new resource to be created. | `list(number)` | <pre>[<br/>  1,<br/>  2,<br/>  3<br/>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| admin\_password | Scale Set admin password. |
| admin\_ssh\_private\_key | Scale Set admin SSH private key. |
| admin\_ssh\_public\_key | Scale Set admin SSH public key. |
| admin\_username | Scale Set admin username. |
| id | Scale Set ID. |
| identity\_principal\_id | Object ID of the Scale Set Managed Service Identity. |
| name | Scale Set name. |
| resource | Scale Set resource object. |
| terraform\_module | Information about this Terraform module |
<!-- END_TF_DOCS -->

## Related documentation

- Microsoft Azure documentation: [docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/)
