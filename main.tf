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


// Contenedor de Redis
resource "docker_container" "redis" {
  name    = "redis"
  image   = var.redis_image
  networks_advanced {
    name = "persistence_net"
  }
  ports {
    internal = 6379
    external = var.redis_port
  }
  restart = "unless-stopped"
}

// Contenedor de Postgres
resource "docker_container" "postgres" {
  name    = "postgres"
  image   = var.postgres_image
  env = [
    "POSTGRES_USER=${var.postgres_user}",
    "POSTGRES_PASSWORD=${var.postgres_password}",
    "POSTGRES_DB=${var.postgres_db}",
  ]
  networks_advanced {
    name = "persistence_net"
  }
  volumes {
    volume_name     = docker_volume.pg_data.name
    container_path  = "/var/lib/postgresql/data"
  }
  ports {
    internal = 5432
    external = var.postgres_host_port
  }
  restart = "unless-stopped"
}

// Contenedor de Grafana
resource "docker_container" "grafana" {
  name    = "grafana"
  image   = "grafana/grafana:main-ubuntu"
  networks_advanced {
    name = docker_network.monitor_net.name
  }
  networks_advanced {
    name = docker_network.app_net.name
  }
  ports {
    internal = 3000
    external = 3000
  }
  env = [
    "GF_SECURITY_ADMIN_USER=admin",
    "GF_SECURITY_ADMIN_PASSWORD=admin",
  ]
  restart = "unless-stopped"
}