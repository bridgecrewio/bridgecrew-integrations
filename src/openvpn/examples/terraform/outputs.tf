output "bridgecrew_cluster_id" {
  value = aws_ecs_cluster.bridgecrew-cluster.id
}

output "bridgecrew_service_discovery_hosted_zone" {
  value = aws_service_discovery_private_dns_namespace.ecs-discovery-namespace.hosted_zone
}

