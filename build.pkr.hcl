build {
  name = "veterinaria-multicloud"

  sources = [
    "source.amazon-ebs.ubuntu_node_nginx",
    "source.azure-arm.azure-node-image"
  ]

  provisioner "shell" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y nodejs npm nginx",
      "mkdir -p /opt/veterinaria-app"
    ]
  }
}
