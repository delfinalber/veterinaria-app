packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.3.0"
    }

    azure = {
      source  = "github.com/hashicorp/azure"
      version = ">= 1.0.0"
    }
  }
}


provider "azure" {
  subscription_id = var.azure_subscription_id
  tenant_id       = var.azure_tenant_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
}





variable "azure_subscription_id" {
  type = string
}

variable "azure_tenant_id" {
  type = string
}

variable "azure_client_id" {
  type = string
}

variable "azure_client_secret" {
  type = string
}

variable "azure_region" {
  type    = string
  default = "westeurope"
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
  name = "multicloud-veterinaria"

  sources = [
    "source.amazon-ebs.veterinaria-aws",   # tu builder principal
    "source.azure-arm.veterinaria-azure"   # este builder Azure
  ]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nodejs npm nginx",
      "mkdir -p /opt/veterinaria-app"
    ]
  }
}

