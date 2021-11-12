resource "random_string" "randomstr" {
    length = 10
    upper = false
    special = false
    provider = random
}

resource "azurerm_resource_group" "poc_hub_tfstate_rg" {
    name = "poc-hub-tfstate-rg"
    location = "East US"
    tags ={
      "created by" = "terraform"
      "Purpose" = "Storage of remote terraform state files"
    }
    provider = azurerm
}

resource "azurerm_storage_account" "poc_hub_tfstate_sa" {
    name = "pochubsa${random_string.randomstr.id}"
     location = azurerm_resource_group.poc_hub_tfstate_rg.location
    resource_group_name = azurerm_resource_group.poc_hub_tfstate_rg.name
    account_replication_type = "GRS"
    account_tier = "Standard"
    tags = azurerm_resource_group.poc_hub_tfstate_rg.tags
    provider = azurerm  
}

resource "azurerm_storage_container" "tfstate" {
    name = "tfstate"
    storage_account_name = azurerm_storage_account.poc_hub_tfstate_sa.name
}