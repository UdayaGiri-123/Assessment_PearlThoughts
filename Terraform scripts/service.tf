# Create App Mesh Resources
resource "aws_appmesh_mesh" "notification_mesh" {
  name = "notification_service"
}

resource "aws_appmesh_virtual_service" "vir_service" {
  mesh_name          = aws_appmesh_mesh.notification_mesh.name
  name               = "notification-service"
  spec {
    provider {
      virtual_node {
        virtual_node_name = aws_appmesh_virtual_node.vir_node.name
      }
    }
  }
}

resource "aws_appmesh_virtual_node" "vir_node" {
  name      = "notification-node"
  mesh_name = aws_appmesh_mesh.notification_mesh.name
  spec {
    listener {
      port_mapping {
        port     = 3000
        protocol = "http"
      }
    }
    service_discovery {
      dns {
        hostname = "notification.local"
      }
    }
  }
}

resource "aws_appmesh_virtual_router" "vir_router" {
  name      = "example-router"
  mesh_name = aws_appmesh_mesh.notification_mesh.name
  spec {
    listener {
      port_mapping {
        port     = 3000
        protocol = "http"
      }
    }
  }
}

resource "aws_appmesh_route" "route" {
  mesh_name           = aws_appmesh_mesh.notification_mesh.name
  virtual_router_name = aws_appmesh_virtual_router.vir_router.name
  name                = "notification-route"
  spec {
    http_route {
      match {
        prefix = "/"
      }
      action {
        weighted_target {
          virtual_node = aws_appmesh_virtual_node.vir_node.name
          weight       = 1
        }
      }
    }
  }
}

# Deploy ECS Service
resource "aws_ecs_service" "ecs-service" {
  name            = "example-service"
  cluster         = aws_ecs_cluster.cluster_service.id
  task_definition = aws_ecs_task_definition.notification_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = ["default"] 
    security_groups = ["default"]   
  }
  service_registries {
    registry_arn = aws_service_discovery_service.service_discovery.arn
  }
}