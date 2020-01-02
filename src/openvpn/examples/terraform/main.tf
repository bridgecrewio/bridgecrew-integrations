/* Terraform to deploy OpenVPN Logstash Docker image to Fargate
   as an ECS service (to restart failed tasks)

  Requires an existing VPN that can talk to your openvpn instance
  as well as egress to the internet.  
  Ideally a private subnet with NAT gateway
*/

// Set AWS provider
provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

// ECS Cluster Definition 
resource "aws_ecs_cluster" "bridgecrew-cluster" {
  name               = "bridgecrew-cluster"
  setting {
    name = "containerInsights"
    value = "enabled"
  }
}

// ECS Task Security Group Definition
resource "aws_security_group" "task_sg" {
  description = "Controls access to logstash containers from OpenVPN hosts"
  vpc_id      = var.vpc_id
  name        = "bridgecrew-openvpn-tasksg"
}

resource "aws_security_group_rule" "allow_task_rsyslog" {
  type                     = "ingress"
  from_port                = 9910
  to_port                  = 9910
  protocol                 = "udp"
  source_security_group_id = "${var.source_security_group_id}"
  cidr_blocks              = var.source_cidr_blocks
  security_group_id        = "${aws_security_group.task_sg.id}"
}

resource "aws_security_group_rule" "allow_task_all_egress" {
  type            = "egress"
  from_port       = "0"
  to_port         = "0"
  protocol        = "-1"
  cidr_blocks     = [ "0.0.0.0/0" ]

  security_group_id = "${aws_security_group.task_sg.id}"
}


// ECS Task Execution Role - Log to CloudWatch - Uncomment ECR if applicable
resource "aws_iam_role" "task_execution_role" {
  name = "bridgecrew-fargate-openvpn-task-execution-role"

  assume_role_policy = data.aws_iam_policy_document.task_execution_assume_role_policy.json
}

data "aws_iam_policy_document" "task_execution_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy" "task_execution_policy" {
  name = "bridgecrew-fargate-task-execution-policy"
  role = aws_iam_role.task_execution_role.id

  policy = data.aws_iam_policy_document.task_execution_policy_document.json
}

data "aws_iam_policy_document" "task_execution_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      //"ecr:GetAuthorizationToken",
      //"ecr:BatchCheckLayerAvailability",
      //"ecr:GetDownloadUrlForLayer",
      //"ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

// AWS Service Discovery / Route 53
resource "aws_service_discovery_private_dns_namespace" "ecs-discovery-namespace" {
  name        = var.dns_namespace
  description = "Bridgecrew Integrations Service Discovery"
  vpc         = var.vpc_id
}

resource "aws_service_discovery_service" "ecs-discovery-service" {
  name = "bridgecrew-openvpn-integration"

  dns_config {
    namespace_id = "${aws_service_discovery_private_dns_namespace.ecs-discovery-namespace.id}"

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }
}

// ECS Container and Task Definition
module "container_definition" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.21.0"

  container_name               = "bridgecrew-openvpn-integration"
  container_image              = var.container_image
  container_cpu                = 1024
  container_memory             = 3072
  container_memory_reservation = 3072
  essential                    = true
  port_mappings                = [
      {
        containerPort = 9910
        hostPort      = 9910
        protocol      = "udp"
      }
  ]
  environment                  = [
      {
        name          = "BC_CUSTOMER_NAME"
        value         = var.bc_customer_name
      },
      {
        name          = "BC_API_TOKEN"
        value         = var.bc_api_token
      },
      {
        name          = "BC_URL"
        value         = var.bc_url
      }
  ]
  log_configuration            = {
    logDriver = "awslogs"
    "options": {
      "awslogs-group": "/ecs/bridgecrew-openvpn-integration",
      "awslogs-region": var.region,
      "awslogs-stream-prefix": "ecs"
    }
    secretOptions = []
  }
}

resource "aws_ecs_task_definition" "openvpn-task" {
  family                   = "bridgecrew-openvpn-integration-td"
  container_definitions    = "[ ${module.container_definition.json_map} ]"
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = [ "FARGATE" ]
  cpu                      = 1024
  memory                   = 3072
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/bridgecrew-openvpn-integration"
  retention_in_days = 30
}

// ECS Service Definition 
resource "aws_ecs_service" "bridgecrew-openvpn-integration" {
  name                               = "bridgecrew-openvpn-integration"
  cluster                            = "${aws_ecs_cluster.bridgecrew-cluster.id}"
  task_definition                    = "${aws_ecs_task_definition.openvpn-task.arn}"
  desired_count                      = 1
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
  launch_type                        = "FARGATE"

  depends_on         = ["aws_cloudwatch_log_group.ecs_logs"]

  network_configuration {
    security_groups  = ["${aws_security_group.task_sg.id}"]
    subnets          = var.subnet_ids
    assign_public_ip = true    // Needed to access internet (Docker Hub / ECR)
  }

  // Allow external changes to desired_count without Terraform plan difference
  lifecycle {
    ignore_changes = ["desired_count"]
  }
  
  // Enable service discovery
  service_registries {
    registry_arn = "${aws_service_discovery_service.ecs-discovery-service.arn}"
  }

}
