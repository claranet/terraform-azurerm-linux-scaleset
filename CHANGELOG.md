# Unreleased

Fixed
  * AZ-973: Update example to align with default `os_disk_size_gb` value and `accelerated_networking`

# v7.1.0 - 2022-11-23

Changed
  * AZ-908: Use the new data source for CAF naming (instead of resource)

# v7.0.0 - 2022-11-10

Breaking
  * AZ-840: Update to Terraform `1.3`
  * AZ-890: Refactor some variables names
  * AZ-890: Extensions as separated resources

Changed
  * AZ-890: Use SSD disks by default
  * AZ-890: Use ephemeral storage for OS on temp disk by default 
  * AZ-890: Change some variables default value
  * AZ-890: Remove Log Analytics agent

# v6.3.0 - 2022-11-04

Added
  * AZ-857: Add `user_data` variable

# v6.2.0 - 2022-09-16

Changed
  * [GH-1](https://github.com/claranet/terraform-azurerm-linux-scaleset/pull/1): Use DCR association resource instead of az rest call
  * AZ-807: Minimum AzureRM provider set to `v3.22`

# v6.1.0 - 2022-06-24

Added
 * AZ-770: Add module info and login info in output

Fix
 * Fix `ssh_public_key` variable description

# v6.0.0 - 2022-05-16

Breaking
  * AZ-717: Bump module for AzureRM provider `v3.0+`

# v5.0.0 - 2022-03-18

Breaking
  * AZ-515: Option to use Azure CAF naming provider to name resources
  * AZ-515: Require Terraform 0.13+

Added
  * AZ-615: Add an option to enable or disable default tags

# v4.1.0 - 2020-10-20

Added
  * AZ-302: Add Azure Monitor and Log analytics agents

Changed
  * AZ-572: Revamp examples and improve CI

# v4.0.0 - 2021-09-07

Added
  * AZ-50: Azure Linux ScaleSet module - initial release
