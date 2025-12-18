# source.amazon-ebs.veterinaria-aws.pkr.hcl

# ⚠️ Sin bloque packer/required_plugins aquí

source "amazon-ebs" "veterinaria-aws" {
  ami_name      = "veterinaria-aws-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-east-1"

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }

  ssh_username = "ubuntu"
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
