variable "name_prefix" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "tags" { type = map(string) }
variable "tenant_id" { type = string }


variable "sample_secret_value" {
  type      = string
  sensitive = true
  default   = "change-me-in-real-life"
}