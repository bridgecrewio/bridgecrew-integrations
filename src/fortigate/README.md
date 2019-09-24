# Fortigate Integration
[![Docker Pulls](https://img.shields.io/docker/pulls/bridgecrew/fortigate-integration)](https://hub.docker.com/r/bridgecrew/fortigate-integration)

The docker contains a running Logstash agent. The docker is collecting data from Fortigate firewall (using syslog) and sends the log data to Bridgecrew cloud in an encrypted secured manner.

## Fortigate

The installation includes 2 steps:   
1. Fortigate syslog configuration   
2. Installing the syslog integration docker 

### 1. Fortigate syslog configuration
connect to fortigate console and run the following command:
```
config log syslogd setting
  set status enable
  set server [IP of the server with the docker]
  set reliable UDP
  set port 9910
  set csv enable
  set facility local7
end
```

### 2. Install the syslog integration docker 
###### Port verification
The port 9910 (UDP) must be open to the fortigate host (listening port).   
Verify that `iptables` is configured to allow incoming traffic on port 9910.

#### Installation

1. ssh into a server where the logstash-docker should be deployed
2. Install docker
3. Verify docker by running the following command: ``` docker info ```
4. Run syslog-integration docker by executing:
```sh
docker run -d -p 9910:9910/udp -e BC_CUSTOMER_NAME=[REPLACE_WITH_CUSTOMER_NAME] -e BC_API_TOKEN=[REPLACE_WITH_API_TOKEN] -e BC_URL="https://logstash.bridgecrew.cloud/logstash" bridgecrew/fortigate-integration
```
