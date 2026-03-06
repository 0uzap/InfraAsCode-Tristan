output "nginx_container_id" {
  description = "Id du container nginx"
  value = docker_container.nginx.id
}