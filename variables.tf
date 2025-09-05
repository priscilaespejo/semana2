variable "app_network_name" {
  type        = string
  description = "Network for app tier (nginx)"
}
variable "monitor_network_name" {
  type        = string
  description = "Network for monitoring (grafana)"
}
variable "persistence_network_name" {
  type        = string
  description = "Network for data services (redis, postgres)"
}
