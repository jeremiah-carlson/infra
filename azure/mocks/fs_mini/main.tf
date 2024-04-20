locals {
  ent = [{
    key = "t1"
    val = "v1"
    }, {
    key = "t2"
    val = "v2"
  }]
}

data "azurerm_resource_group" "fs_mini_rg" {
  name = var.fs_mini.resource_group_name
}

resource "azurerm_storage_account" "fs_mini_sta" {
  name                     = var.fs_mini.storage_account_name
  resource_group_name      = data.azurerm_resource_group.fs_mini_rg.name
  location                 = data.azurerm_resource_group.fs_mini_rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_table" "fs_mini_stc" {
  name                 = var.fs_mini.base_table_name
  storage_account_name = azurerm_storage_account.fs_mini_sta.name
}

resource "azurerm_storage_table_entity" "base_entities" {
  for_each = {
    for index, ent in local.ent :
    ent.key => ent
  }
  storage_account_name = azurerm_storage_account.fs_mini_sta.name
  table_name           = azurerm_storage_table.fs_mini_stc.name
  partition_key        = "t1"
  row_key              = each.value.key

  entity = {
    val = each.value.val
  }
}
