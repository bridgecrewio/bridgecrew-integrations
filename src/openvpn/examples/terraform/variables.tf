variable "region" {
  type        = "string"
  description = "The AWS region"
}

variable "aws_profile" {
  type = "string"
}

variable "vpc_id" {
  type        = "string"
  description = "An existing VPC ID where your servers exist"
}

variable "subnet_ids" {
  type        = "list"
  description = "The Subnets to use within your VPC" 
}

// Define only source_security_group_id OR source_cidr_blocks.  Not Both!
variable "source_security_group_id" {
  type        = "string"
  description = "The source security group to allow to communicate with Logstash"
  default     = null
}

variable "source_cidr_blocks" {
  type        = "list"
  description = "The source CIDR to allow to communicate with Logstash (i.e. 10.0.0.0/16)"
  default     = null
}

variable "dns_namespace" {
  type        = "string"
  description = "The private DNS namespace to create for resolution of the logstash container"
  default     = "bridgecrew.local"
}

variable "container_image" {
  type        = "string"
  description = "The location of the openvpn-integration Docker image"
  default     = "https://hub.docker.com/r/bridgecrew/openvpn-integration" 
}

variable "bc_customer_name" {
  type        = "string"
  description = "Your Bridgecrew customer name" 
}

variable "bc_api_token"  {
  type        = "string"
  description = "Your Bridgecrew API token"
}

variable "bc_url" {
  type        = "string"
  description = "The URL to connect to Bridgecrew"
  default     = "https://logstash.bridgecrew.cloud/logstash"
}
