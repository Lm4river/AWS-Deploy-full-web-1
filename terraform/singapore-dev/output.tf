output "alb_dns" {
  value = module.load_balance.alb_dns
}
output "mongo_db_endpoint" {
  value = module.database.mongodb_endpoint
}
