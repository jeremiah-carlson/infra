variable "fs_mini" {
  type = map(string)
  default = {
    "resource_group_name"  = ""
    "storage_account_name" = ""
    "base_table_name"      = "base"
  }
}
