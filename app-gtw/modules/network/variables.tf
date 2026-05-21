variable vnet_name {
  default = "app-vnet"
}

variable vnet_address_space {
  default = ["10.0.0.0/16"]
}

variable appgw_subnet_prefixes {
  default = ["10.0.1.0/24"]
}

variable backend_subnet_prefixes {
  default = ["10.0.2.0/24"]
}
variable resource_group_name {}
variable location {}