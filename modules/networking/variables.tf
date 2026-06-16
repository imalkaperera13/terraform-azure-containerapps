variable "name_prefix" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "tags" { type = map(string) }

variable "vnet_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}