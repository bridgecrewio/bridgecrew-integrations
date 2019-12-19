# OpenVPN log integration Terraform Deployment

This is an example of deploying the openvpn-integration as a container on Fargate.  This will provision the following: 

- Route 53 private hosted zone (AWS service discovery)
- Fargate Cluster
- Fargate Service and Single ECS Task (with associated IAM roles)
- Security Group to restrict ingress by CIDR or source security group
- CloudWatch Logs group to collect ECS logs

## Example Usage

Update the parameters for your deployment.  Details as follows: 

- container_image: Pull the specific tag from https://hub.docker.com/r/bridgecrew/openvpn-integration
- vpc_id: The VPC where your hosts exist for logging. 
- subnet_ids: The ID or IDs of subnets to use.  Note these must have a path to Docker Hub
- Set either source_cidr_blocks to the blocks your hosts are in **OR** set source_security_group_id
- Enter your Bridgecrew customer name and API token

```
cp example-params.tfvars params.tfvars
vi params.tfvars

container_image="bridgecrew/openvpn-integration:latest"
vpc_id = "vpc-xxxxxx1"
subnet_ids = ["subnet-xxxxxx1", "subnet-xxxxxx2", "subnet-xxxxxx3"]
// Set either source_security_group_id OR source_cidr_block for security group ingress
// You cannot set both
// source_security_group_id = "sg-xxxxxxxx"
source_cidr_blocks = ["10.10.0.0/24"]

bc_customer_name = "test"
bc_api_token = "my-api-token"
```

Now you can provision with Terraform: 

```
terraform init
terraform plan -var-file=params.tfvars
terraform apply -var-file=params.tfvars
```

Now setup your syslog configuration to point to bridgecrew-openvpn-integration.bridgecrew.local on port 9910/udp


