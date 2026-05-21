variable resource_group_name {
    type = string
}

variable location {
    type = string
}

variable vnet_name {
    type = string
    }

variable vnet_address_space {
    type = list(string)
}

variable public_subnet_name {
    type = string
}

variable public_subnet_address_prefixes {
    type = list(string)
}

variable private_subnet_name {
    type = string
}

variable private_subnet_address_prefixes {
    type = list(string)
}

variable pubvm_public_ip_name {
    type = string
}

variable pubvm_nsg_name {
    type = string
}

variable pubvm_nic_name{
    type = string
}

variable pubvm_name {
    type = string
}

variable pubvm_size {
    type = string
}

variable pubvm_admin_username {
    type = string
}

variable pubvm_admin_password {
    type = string
    sensitive = true
}

variable LB_public_ip_name {
    type = string
}

variable LB_name {
    type = string
}

variable LB_frontend_ip_configuration_name {
    type = string
}

variable LB_backend_address_pool_name {
    type = string
}

variable LB_probe_name {
    type = string
}

variable LB_rule_name {
    type = string
}

variable privm_nsg_name {
    type = string
}

variable privm_nic_name {
    type = string
}

variable privm_name {
    type = string
}

variable privm_size {
    type = string
}

variable privm_admin_username {
    type = string
}
variable privm_admin_password {
    type = string
    sensitive = true
}
