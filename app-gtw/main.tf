module "rg" {
  source = "./modules/resource_group"
  resource_group_name = var.resource_group_name
  location = var.location
}

module "network" {
  source = "./modules/network"
  resource_group_name = module.rg.resource_group_name
  location = module.rg.location
}

module "nsg" {
  source = "./modules/nsg"
  resource_group_name = module.rg.resource_group_name
  location = module.rg.location
  backend_subnet_id = module.network.backend_subnet_id
}

module "vm1" {
  source = "./modules/vm"
  vm_name = "app1-vm"
  resource_group_name = module.rg.resource_group_name
  location = module.rg.location
  subnet_id = module.network.backend_subnet_id
  admin_username = var.admin_username
  admin_password = var.admin_password
  custom_message = "APP1 SERVER"
}

module "vm2" {
  source = "./modules/vm"
  vm_name = "app2-vm"
  resource_group_name = module.rg.resource_group_name
  location = module.rg.location
  subnet_id = module.network.backend_subnet_id
  admin_username = var.admin_username
  admin_password = var.admin_password
  custom_message = "APP2 SERVER"
}

module "nat_gateway" {
  source              = "./modules/nat_gateway"
  resource_group_name = module.rg.resource_group_name
  location            = module.rg.location
  backend_subnet_id   = module.network.backend_subnet_id
}

module "waf" {
  source = "./modules/waf"
  resource_group_name = module.rg.resource_group_name
  location = module.rg.location
}

module "app_gateway" {
  source = "./modules/app_gateway"
  resource_group_name = module.rg.resource_group_name
  location = module.rg.location
  subnet_id = module.network.appgw_subnet_id
  backend1_private_ip = module.vm1.private_ip
  backend2_private_ip = module.vm2.private_ip
  waf_policy_id = module.waf.waf_policy_id
}