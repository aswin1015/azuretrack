variable "location" {
  default = "Central India"
}

variable "resource_group_name" {
  default = "aswin-rg"
}

variable "admin_username" {
  default = "aswin1015"
}

variable "admin_password" {
  sensitive = true
}