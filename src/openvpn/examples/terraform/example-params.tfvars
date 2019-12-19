region             = "us-west-2"
aws_profile        = "default"
container_image    = "bridgecrew/openvpn-integration:latest"
vpc_id             = "vpc-xxxxxx1"
subnet_ids         = ["subnet-xxxxxx1", "subnet-xxxxxx2", "subnet-xxxxxx3"]

// Set either source_security_group_id OR source_cidr_block for security group ingress 
// You cannot set both 
// source_security_group_id = "sg-xxxxxxxx"
source_cidr_blocks = ["10.10.0.0/24"]

bc_customer_name   = "test"
bc_api_token       = "my-api-token"
bc_url             = "https://logstash.bridgecrew.cloud/logstash"

