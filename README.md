# Infra local con Terraform + Docker
Despliegue de 3 instancias NGINX (`app1`, `app2`, `app3`) sobre una red de aplicación; Redis y PostgreSQL en una red de persistencia; y Grafana compartiendo red con la app y su red de monitoreo. Todo orquestado con el proveedor `kreuzwerker/docker` de Terraform.

## Arquitectura

[ Host ] ─ Docker Engine
├─ Redes:
│ ├─ app_net ← apps NGINX (app1, app2, app3) y Grafana
│ ├─ persistence_net ← Redis y PostgreSQL
│ └─ monitor_net ← Grafana
│
├─ Contenedores:
│ ├─ app1 (nginx:stable-alpine3.21-perl) :80 -> host:8001 [app_net]
│ ├─ app2 (nginx:stable-alpine3.21-perl) :80 -> host:8002 [app_net]
│ ├─ app3 (nginx:stable-alpine3.21-perl) :80 -> host:8003 [app_net]
│ ├─ redis (var.redis_image) :6379 -> host:${redis_port} [persistence_net]
│ ├─ postgres (var.postgres_image) :5432 -> host:${postgres_host_port} [persistence_net]
│ └─ grafana (grafana/grafana:main-ubuntu) :3000 -> host:3000 [app_net, monitor_net]
│ env: GF_SECURITY_ADMIN_USER=admin, GF_SECURITY_ADMIN_PASSWORD=admin
│
└─ Volúmenes:
└─ pg_data → /var/lib/postgresql/data (persistencia de PostgreSQL)




## Requisitos

- Docker instalado y en ejecución.
- Terraform 1.6+.
- Permisos para crear redes/volúmenes en Docker.

## Estructura sugerida

├─ main.tf # Recursos (redes, contenedores, volúmenes)
├─ variables.tf # Declaración de variables
├─ terraform.tfvars # Valores concretos (credenciales/puertos/tags)
└─ outputs.tf # (Opcional) Salidas útiles

postgres_user        = "admin"
postgres_password    = "admin123"
postgres_db          = "testdb"
postgres_image       = "postgres:16.3-bookworm"
postgres_host_port   = 5432
postgres_volume_name = "pg_data_volume"

redis_image = "redis:7.2.5-alpine"
redis_port  = 6379

# Despliegue

terraform init
terraform fmt -recursive
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
# o: terraform apply -auto-approve

