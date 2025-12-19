packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.0.0"
    }
    azure = {
      source  = "github.com/hashicorp/azure"
      version = ">= 2.0.0"
    }
  }
}


variable "aws_region" {
  default = "us-east-1"
}

source "amazon-ebs" "ubuntu_node_nginx" {
  region                  = var.aws_region
  instance_type           = "t3.micro"
  ami_name                = "ubuntu-node-nginx-{{timestamp}}"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = ["099720109477"] # Canonical
    most_recent = true
  }
  ssh_username = "ubuntu"
}



# BUILDER AZURE (añadido)
source "azure-arm" "azure-node-image" {
  subscription_id                   = var.azure_subscription_id
  client_id                         = var.azure_client_id
  client_secret                     = var.azure_client_secret
  tenant_id                         = var.azure_tenant_id

  managed_image_resource_group_name = "rg-veterinaria-img"
  managed_image_name                = "img-veterinaria-node"
 
  os_type          = "Linux"
  image_publisher  = "Canonical"
  image_offer      = "0001-com-ubuntu-server-focal"
  image_sku        = "20_04-lts"
}


 
 
