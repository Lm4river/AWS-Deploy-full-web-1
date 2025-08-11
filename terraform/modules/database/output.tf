output "mongodb_endpoint"{
  value = aws_docdb_cluster.mongodb_cluster.endpoint
}
output "mongodb_password_secret_arn" {
  value = aws_secretsmanager_secret.mongodb_password_secret.arn
}
output "mongodb_connection_string_secret_arn" {
  value = aws_secretsmanager_secret.mongodb_connection_string.arn
}
