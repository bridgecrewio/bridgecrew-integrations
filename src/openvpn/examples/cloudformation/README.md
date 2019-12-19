# OpenVPN log integration CloudFormation Deployment

This is an example of deploying the openvpn-integration as a container on Fargate.  This will provision the following: 

- Route 53 private hosted zone (AWS service discovery)
- Fargate Cluster
- Fargate Service and Single ECS Task (with associated IAM roles)
- Security Group to restrict ingress by CIDR or source security group
- CloudWatch Logs group to collect ECS logs

## Example Usage

- Create a new stack in CloudFormation: [https://console.aws.amazon.com/cloudformation/?#/stacks/create/template](https://console.aws.amazon.com/cloudformation/?#/stacks/create/template])
- Click 'Create stack' -> 'with new resources (standard)'
- Select 'Upload a template file'.  There are 2 templates.  One for ingress from source CIDR range and one for ingress from source securiry group.  Select the appropriate template, upload it, and click 'Next'
- Fill in the parameters as follows:
  - Stack name: Bridgecrew-OpenVPN-Integration
  - VPC ID: <Select your VPC>
  - Subnet Ids: <Select your subnets>
  - Private DNS Namespace: bridgecrew.local
  - Container image: https://hub.docker.com/r/bridgecrew/openvpn-integration
  - Select either a source Security group OR input CIDR block.  
  - Enter your customer name
  - Enter your API token 
  - Enter the Bridgecrew URL 
- Click 'Next' 
- Click 'Next' on the 'Configure stack options' screen
- Check the box to say 'I acknowledge that AWS CloudFormation might create IAM resources with custom names".  This is the task execution role
- Click 'Create stack' 

Now setup your syslog configuration to point to bridgecrew-openvpn-integration.bridgecrew.local on port 9910/udp


