build {
  name = "veterinaria-multicloud"

  sources = [
    "source.amazon-ebs.ubuntu_node_nginx",
    "source.azure-arm.azure-node-image"
  ]

  provisioner "shell" {
    inline = [
      "sudo apt-get update -y",
      "curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -",
      "sudo apt-get install -y nodejs nginx",
      "sudo systemctl enable nginx",
      # aquí puedes reutilizar el inline que ya tenías
    ]
  }
}
