module "resource_group" {
  source = "./modules/resource_group"
  resource_group_name = var.resource_group_name
  location = var.location
}

module "vnet" {
  source = "./modules/vnet"
  location = var.location
  resource_group_name = var.resource_group_name

  depends_on = [ module.resource_group ]
}


module "subnet" {
  source = "./modules/subnet"
  resource_group_name = var.resource_group_name
  vnet_name = module.vnet.vnet_name

  depends_on = [ module.vnet ]
}

module "nat_gateway" {
  source = "./modules/nat_gateway"
  location = var.location
  resource_group_name = var.resource_group_name
  subnet_id = module.subnet.subnet_id

  depends_on = [ module.subnet ]
}

module "load_balancer" {
  source = "./modules/load_balancer"
  location = var.location
  resource_group_name = var.resource_group_name

  depends_on = [ module.resource_group ]
}

module "vmss" {
  source = "./modules/vmss"
  resource_group_name = var.resource_group_name
  location = var.location
  subnet_id = module.subnet.subnet_id
  backend_pool_id = module.load_balancer.backend_pool_id

  depends_on = [ module.subnet, module.load_balancer, module.nat_gateway ]
}

module "autoscale" {
  source = "./modules/autoscale"
  resource_group_name = var.resource_group_name
  location = var.location
  vmss_id = module.vmss.vmss_id

  depends_on = [ module.vmss ]
}

module "monitor" {
  source = "./modules/monitor"
  resource_group_name = var.resource_group_name
  location = var.location

  depends_on = [ module.resource_group ]
}

module "bastion" {
  source = "./modules/bastion"
  resource_group_name = var.resource_group_name
  location = var.location
  vnet_name = module.vnet.vnet_name

  depends_on = [ module.resource_group, module.subnet ]

}

module "alert" {

  source = "./modules/alert"

  resource_group_name = var.resource_group_name

  vmss_id = module.vmss.vmss_id

  email_address = var.email_address

  depends_on = [
    module.vmss
  ]
}