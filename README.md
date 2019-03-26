# Azure ScaleSet
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| accelerated\_networking | Specifies whether to enable accelerated networking or not | `string` | `"false"` | no |
| admin\_password | Password for the administrator account of the virtual machine. | `string` | `null` | no |
| admin\_username | Username to use as admin user | `string` | n/a | yes |
| application\_gateway\_backend\_address\_pool\_ids | Specifies an array of references to backend address pools of application gateways. A scale set can reference backend address pools of one application gateway | `list(string)` | `[]` | no |
| application\_security\_group\_ids | Specifies up to 20 application security group IDs | `list(string)` | `[]` | no |
| automatic\_instance\_repair | Enable automatic instance repair. Must have health\_probe\_id or an Application Health Extension | `bool` | `false` | no |
| automatic\_os\_upgrade | Automatic OS patches can be applied by Azure to your scaleset. This is particularly useful when upgrade\_policy\_mode is set to Rolling. | `bool` | `false` | no |
| boot\_diagnostics\_storage\_uri | Blob endpoint for the storage account to hold the virtual machine's diagnostic files | `string` | `""` | no |
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| custom\_data | The Base64-Encoded Custom Data which should be used for this Virtual Machine Scale Set. | `string` | `null` | no |
| custom\_ipconfig\_name | Custom name for Ipconfiguration | `string` | `null` | no |
| custom\_nic\_name | Custom name for Network Interfaces | `string` | `null` | no |
| custom\_vmss\_name | Custom name for the Virtual Machine ScaleSet | `string` | `null` | no |
| disable\_automatic\_rollback | Disable automatic rollback in case of failured | `bool` | `false` | no |
| dns\_settings | Specifies an array of dns servers | `list(string)` | `[]` | no |
| environment | Project environment | `any` | n/a | yes |
| eviction\_policy | Specifies the eviction policy for Virtual Machines in this Scale Set, eviction\_policy can only be set when priority is set to Low [Possible values : Deallocate and Delete] | `string` | `"Deallocate"` | no |
| extensions | Can be specified to add extension profiles to the scale set | `map(any)` | `{}` | no |
| extra\_tags | Additional tags to associate with your network security group. | `map(string)` | `{}` | no |
| health\_probe\_id | Specifies the identifier for the load balancer health probe. Required when using Rolling as your upgrade\_policy\_mode. | `string` | `""` | no |
| identity | Map with identity block informations as described here https://www.terraform.io/docs/providers/azurerm/r/linux_virtual_machine_scale_set.html#identity | <pre>object({<br>    type         = string<br>    identity_ids = list(string)<br>  })</pre> | `null` | no |
| instances\_count | Specify the number of instances to run | `number` | `1` | no |
| ip\_forwarding | Whether IP forwarding is enabled on this NIC | `string` | `"false"` | no |
| load\_balancer\_backend\_address\_pool\_ids | Specifies an array of references to backend address pools of load balancers. A scale set can reference backend address pools of one public and one internal load balancer | `list(string)` | `[]` | no |
| load\_balancer\_inbound\_nat\_rules\_ids | Specifies an array of references to inbound NAT rules for load balancers | `list(string)` | `[]` | no |
| location | Azure region to use | `any` | n/a | yes |
| location\_short | Short string for Azure location | `any` | n/a | yes |
| network\_security\_group\_id | Specifies the identifier for the network security group | `string` | `""` | no |
| os\_type | OS type used with VMSS (linux or windows) | `string` | `"linux"` | no |
| priority | Specifies the priority for the Virtual Machines in the Scale Set. [Possible values : Low and Regular] | `string` | `"Regular"` | no |
| public\_ip\_address\_configuration | Describes a virtual machines scale set IP Configuration's PublicIPAddress configuration | `list(string)` | `[]` | no |
| resource\_group\_name | Name of the resource group | `any` | n/a | yes |
| rolling\_upgrade\_policy | This is only applicable when the upgrade\_policy\_mode is Rolling. | <pre>object({<br>    max_batch_instance_percent              = number<br>    max_unhealthy_instance_percent          = number<br>    max_unhealthy_upgraded_instance_percent = number<br>    pause_time_between_batches              = string<br>  })</pre> | <pre>{<br>  "max_batch_instance_percent": 25,<br>  "max_unhealthy_instance_percent": 25,<br>  "max_unhealthy_upgraded_instance_percent": 25,<br>  "pause_time_between_batches": "PT30S"<br>}</pre> | no |
| scale\_in\_policy | The scale-in policy rule that decides which virtual machines are chosen for removal when a Virtual Machine Scale Set is scaled in. Possible values for the scale-in policy rules are Default, NewestVM and OldestVM, defaults to Default | `string` | `"Default"` | no |
| source\_image\_id | Id of the image to use. | `string` | `null` | no |
| source\_image\_reference | Source Image references | <pre>object({<br>    publisher = string<br>    offer     = string<br>    sku       = string<br>    version   = string<br>  })</pre> | `null` | no |
| ssh\_public\_key | Path to the public SSH key deployed on Scale set | `string` | `null` | no |
| stack | Project stack name | `any` | n/a | yes |
| storage\_profile\_data\_disk | A storage profile data disk | `list(string)` | `[]` | no |
| storage\_profile\_os\_disk\_caching | Specifies the caching requirements [Possible values : None, ReadOnly, ReadWrite] | `string` | `"None"` | no |
| storage\_profile\_os\_disk\_managed\_disk\_type | Specifies the type of managed disk to create [Possible values : Standard\_LRS, StandardSSD\_LRS or Premium\_LRS] | `string` | `"Standard_LRS"` | no |
| storage\_profile\_os\_disk\_size\_gb | Size of the OS disk in GB | `number` | `32` | no |
| subnet\_id | Specifies the identifier of the subnet | `string` | n/a | yes |
| upgrade\_mode | Specifies how Upgrades (e.g. changing the Image/SKU) should be performed to Virtual Machine Instances. Possible values are Automatic, Manual and Rolling. Defaults to Manual. | `string` | `"Manual"` | no |
| vms\_sku | Specifies the size of virtual machines in a scale set | `string` | n/a | yes |
| zone\_balance | Should the Virtual Machines in this Scale Set be strictly evenly distributed across Availability Zones? Changing this forces a new resource to be created. | `bool` | `true` | no |
| zones\_list | A list of Availability Zones in which the Virtual Machines in this Scale Set should be created in. Changing this forces a new resource to be created. | `list(number)` | <pre>[<br>  1,<br>  2,<br>  3<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| scale\_set\_id | Scale Set ID |
| system\_assigned\_identity | Identity block with principal ID |

