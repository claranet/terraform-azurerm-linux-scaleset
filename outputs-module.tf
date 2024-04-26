output "terraform_module" {
  description = "Information about this Terraform module"
  value = {
    name       = "linux-scaleset"
    provider   = "azurerm"
    maintainer = "claranet"
  }
}
