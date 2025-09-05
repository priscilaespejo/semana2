# PostgreSQL
postgres_user        = "admin"
postgres_password    = "admin123"
postgres_db          = "testdb"
postgres_image       = "postgres:16.3-bookworm"
postgres_host_port   = 5432
postgres_volume_name = "pg_data_volume"

# Redis
redis_image          = "redis:7.2.5-alpine"
redis_port           = 6379