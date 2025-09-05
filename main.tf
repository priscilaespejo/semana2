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

resource "docker_network" "app_net" {
  name    = "app_net"
  driver  = "bridge"
}

resource "docker_network" "persistence_net" {
  name    = "persistence_net"
  driver  = "bridge"
}
resource "docker_network" "monitor_net" {
  name    = "monitor_net"
  driver  = "bridge"
}

// App containers (app1, app2, app3)
resource "docker_container" "app1" {
  name    = "app1"
  image   = "nginx:stable-alpine3.21-perl"
  networks_advanced {
    name  = "app_net"
  }
  ports {
    internal = 80
    external = 8001
  }
}

resource "docker_container" "app2" {
  name    = "app2"
  image   = "nginx:stable-alpine3.21-perl"
  networks_advanced {
    name  = "app_net"
  }
  ports {
    internal = 80
    external = 8002
  }
}

resource "docker_container" "app3" {
  name    = "app3"
  image   = "nginx:stable-alpine3.21-perl"
  networks_advanced {
    name  = "app_net"
  }
  ports {
    internal = 80
    external = 8003
  }
}
// Volumen de persistencia de Postgres
resource "docker_volume" "pg_data" {
  name = var.postgres_volume_name
}
