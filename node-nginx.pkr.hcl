packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.0.0"
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

build {
  name    = "ubuntu-node-nginx-build"
  sources = ["source.amazon-ebs.ubuntu_node_nginx"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update -y",
      # Node.js (v18 LTS)
      "curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -",
      "sudo apt-get install -y nodejs",
      # Nginx
      "sudo apt-get install -y nginx",
      "sudo systemctl enable nginx",
      # App Node.js básica
      "sudo mkdir -p /var/www/nodeapp",
      "sudo chown ubuntu:ubuntu /var/www/nodeapp",
      "cd /var/www/nodeapp && npm init -y",
      "cd /var/www/nodeapp && npm install express",
     "echo \"const express = require('express'); const app = express(); const port = 3000; app.get('/', (req, res) => { res.send('Hola desde Node.js detrás de Nginx'); }); app.listen(port, () => { console.log('Servidor escuchando en puerto ' + port); });\" | sudo tee /var/www/nodeapp/index.js",
      "sudo systemctl restart nginx",
      # Configuración de la app Node.js como servicio systemd
      # Systemd service para la app
      "echo \"[Unit]\nDescription=Node.js App\nAfter=network.target\n\n[Service]\nExecStart=/usr/bin/node /var/www/nodeapp/index.js\nRestart=always\nUser=ubuntu\nEnvironment=NODE_ENV=production\nWorkingDirectory=/var/www/nodeapp\n\n[Install]\nWantedBy=multi-user.target\" | sudo tee /etc/systemd/system/nodeapp.service",
      # Systemd service para el proxy inverso
      "sudo systemctl daemon-reload",
      "sudo systemctl enable nodeapp",
      "sudo systemctl start nodeapp",
      # Configuración Nginx como proxy inverso
      "echo \"server { listen 80; server_name _; location / { proxy_pass http://127.0.0.1:3000; proxy_http_version 1.1; proxy_set_header Upgrade $http_upgrade; proxy_set_header Connection 'upgrade'; proxy_set_header Host $host; proxy_set_header X-Real-IP $remote_addr; proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; proxy_set_header X-Forwarded-Proto $scheme; } }\" | sudo tee /etc/nginx/sites-available/nodeapp",

      "sudo rm -f /etc/nginx/sites-enabled/default",
      "sudo ln -s /etc/nginx/sites-available/nodeapp /etc/nginx/sites-enabled/nodeapp",
      "sudo nginx -t",
      "sudo systemctl restart nginx"
    ]
  }
}

 {
 
}