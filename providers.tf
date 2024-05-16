terraform {
  backend "azurerm" {
    resource_group_name  = "test-resource"  # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
    storage_account_name = "t3t51238"                      # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "testcontainer"                       # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "prod.terraform.tfstate"        # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  required_version = "1.8.3"
}


provider "azurerm" {
  features {}

  client_id       = "8131ecc3-95fa-47cb-88d6-d455db66d017"
  client_secret   = "kDt8Q~JQXYa9DueKazyWObeN_ly1tKWyub18QdlE"
  tenant_id       = "45b40b0c-46b5-4544-abdf-cf31a3decec1"
  subscription_id = "cd0d1198-f546-451f-a392-bc1307240c52"

}
