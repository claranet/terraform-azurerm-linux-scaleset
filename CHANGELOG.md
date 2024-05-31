## 7.3.2 (2024-05-31)


### Bug Fixes

* **AZ-1415:** fix perpetual drift on azure monitor agent extension 24714c2


### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.7.0 f568ba8
* **deps:** update dependency opentofu to v1.7.1 48ac9b9
* **deps:** update dependency pre-commit to v3.7.1 b57d731
* **deps:** update dependency terraform-docs to v0.18.0 f14e9ac
* **deps:** update dependency tflint to v0.51.0 46d400b
* **deps:** update dependency tflint to v0.51.1 60fa382
* **deps:** update dependency trivy to v0.50.4 98f2d17
* **deps:** update dependency trivy to v0.51.0 75130f1
* **deps:** update dependency trivy to v0.51.1 83df222
* **deps:** update dependency trivy to v0.51.2 ea70585
* **deps:** update dependency trivy to v0.51.4 de16cf1

## 7.3.1 (2024-04-26)


### Styles

* **output:** remove unused version from outputs-module 0ccbe7d


### Continuous Integration

* **AZ-1391:** enable semantic-release [skip ci] e796bb8
* **AZ-1391:** update semantic-release config [skip ci] 831b481


### Miscellaneous Chores

* **deps:** enable automerge on renovate b4e72c1
* **deps:** update dependency trivy to v0.50.2 435c847
* **pre-commit:** update commitlint hook 0cd2f14
* **release:** remove legacy `VERSION` file 5e503c1

# v7.3.0 - 2024-04-12

Added
  * AZ-1342: Add `encryption_at_host_enabled` parameter

# v7.2.0 - 2023-01-23

Added
  * AZ-985: Add option to disable Azure Monitor: Agent + Data Collection Rule

Changed
  * AZ-985: Update Azure Monitor resources naming to align with new condition

# v7.1.1 - 2023-01-13

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
