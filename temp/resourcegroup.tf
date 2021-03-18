# pre-requisite - provider details should be available

resource "azurerm_resource_group" "tf_rg" {
  name     = "tf_rg"
  location = "eastus"
}