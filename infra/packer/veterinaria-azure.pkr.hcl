packer {
  required_version = ">= 1.7.0"
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = ">= 1.0.0"
    }
  }
}


variable "tenant_id"      {}
variable "subscription_id" {}
variable "client_id"      {}
variable "client_secret"  {}

variable "resource_group" {
  default = "rg-veterinaria-images"
}
variable "location" {
  default = "eastus"
}

source "azure-arm" "veterinaria-azure" {
  client_id                         = var.client_id
  client_secret                     = var.client_secret
  subscription_id                   = var.subscription_id
  tenant_id                         = var.tenant_id

  managed_image_resource_group_name = var.resource_group
  managed_image_name                = "veterinaria-azure-image"
  location                          = var.location
  vm_size                           = "Standard_B1s"

  os_type         = "Linux"
  image_publisher = "Canonical"
  image_offer     = "0001-com-ubuntu-server-jammy"
  image_sku       = "22_04-lts"
}

build {
  name    = "veterinaria-multicloud-ready"
  sources = ["source.azure-arm.veterinaria-azure"]

  provisioner "shell" {
    script = "scripts/install_veterinaria.sh"
  }
}
