  resource "docker_container" "ubuntu" {
  name  = "nginx"
  image = "nginx:stable-alpine3.21-perl"
  ports {
    internal = 80
    external = 3000
    
  }
}
resource "docker_image" "grafana" {
  name = "grafana"
}

resource "docker_image" "redis" {
  name = "redis"
}

resource "docker_image" "postgres" {
  name = "postgres"
  
}
