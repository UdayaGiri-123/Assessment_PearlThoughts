resource "aws_vpc" "example" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true   
  enable_dns_hostnames = true
}

resource "aws_service_discovery_private_dns_namespace" "dns_namespace" {
  name        = "notification.local"
  vpc         = aws_vpc.example.id
}

resource "aws_service_discovery_service" "service_discovery" {
  name = "notification_service"
  force_destroy = true
  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.dns_namespace.id

    dns_records {
      ttl  = 3
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}