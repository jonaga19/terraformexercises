variable "winvm_name" {
  type        = string
  description = "windows vm name"
}
variable "winvm_adminuser" {
  type        = string
  description = "windows admin user"
  sensitive = true
}
variable "winvm_adminpassword" {
  type        = string
  description = "windows admin password"
}