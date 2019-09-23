# Docker-Linux-Auth-Integration
The docker contains a running Logstash agent. The docker is collecting data from linux auth.log (using syslog) and sends the log data to Bridgecrew cloud in an encrypted secured manner.

## Linux Auth

The installation includes 2 steps:   
1. `auth.log` syslog configuration   
2. Installing the syslog integration docker 

### 1. Linux syslog configuration
TODOOOOO

### 2. Install the syslog integration docker 
###### Port verification
The port 514 (UDP) must be open between the to the fortigate host (listening port).   
Verify that `iptables` is configured to allow incoming traffic on port 514.

#### Installation

1. ssh into a server where the logstash-docker should be deployed
2. Install docker
3. Verify docker by running the following command: ``` docker info ```
4. Run syslog-integration docker by executing:
```sh
docker run -d -p 514:514/udp -e BC_CUSTOMER_NAME=[REPLACE_WITH_CUSTOMER_NAME] -e BC_API_TOKEN=[REPLACE_WITH_API_TOKEN] -e BC_URL="https://logstash.bridgecrew.cloud/logstash" bridgecrew/linux-auth-integration
```
