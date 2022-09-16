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
