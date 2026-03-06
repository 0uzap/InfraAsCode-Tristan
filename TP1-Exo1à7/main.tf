terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.5.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "nginx" {
  name         = var.docker_image
  keep_locally = true
}

resource "docker_container" "nginx" {
  name  = var.container_docker
  image = docker_image.nginx.image_id
  ports {
    internal = var.port_interne
    external = var.port_externe
  }
  provisioner "local-exec" {
    command = "curl -s http://localhost:${var.port_externe} | findstr Welcome"
  }
  networks_advanced {
    name = docker_network.network.name
  }
}


resource "docker_image" "client" {
  name         = "appropriate/curl"
  keep_locally = true
}

resource "docker_container" "client" {
  for_each = toset(var.servers)

  name = "${each.value}"
  image = docker_image.client.image_id

  networks_advanced {
    name = docker_network.network.name
  }
    command = ["sh", "-c", "curl -s http://${var.container_docker}:80 && sleep 3600" ] 
    
    depends_on = [ docker_container.nginx ]
}

resource "docker_network" "network" {
  name = "network"
}