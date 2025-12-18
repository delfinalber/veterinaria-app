packer {
  required_version = ">= 1.7.0"

  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.3.0"
    }

    
  }
}


variable "azure_subscription_id" {}
variable "azure_tenant_id"       {}
variable "azure_client_id"       {}
variable "azure_client_secret"   {}
variable "azure_region" {
  default = "westeurope"
}

source "azure-arm" "azure-node-image" {
  subscription_id       = var.azure_subscription_id
  client_id             = var.azure_client_id
  client_secret         = var.azure_client_secret
  tenant_id             = var.azure_tenant_id

  managed_image_name    = "veterinaria-node-image"
  managed_image_rg_name = "packer-veterinaria_group"
  location              = var.azure_region

  os_type               = "Linux"
  image_publisher       = "Canonical"
  image_offer           = "0001-com-ubuntu-server-jammy"
  image_sku             = "22_04-lts"
  vm_size               = "Standard_D2s_v3"
}
