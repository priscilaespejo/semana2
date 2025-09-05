terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "3.6.2"
    }
  }
}

provider "docker" {

}
  resource "docker_container" "ubuntu" {
  name  = "nginx"
  image = "nginx:stable-alpine3.21-perl"
  ports {
    internal = 80
    external = 3000
    
  }
}