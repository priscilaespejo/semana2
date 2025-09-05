// VAriables de Postgres
variable "postgres_user" {
  type      = string
  default   = "admin"
}
variable "postgres_password" {  
  type      = string
  default   = "password"
  sensitive = true
}
variable "postgres_db" {
  type      = string
  default   = "appdb"
}
variable "postgres_image" {
  type      = string
  default   = "postgres:13.22-alpine3.22"
}
variable "postgres_volume_name" {
  type      = string
  default   = "pg_data"
}
variable "postgres_host_port" {
  type      = number
  default   = 5432
}
