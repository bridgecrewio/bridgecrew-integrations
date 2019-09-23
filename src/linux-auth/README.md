# Docker-Linux-Auth-Integration
The docker contains a running Logstash agent. The docker is collecting data from linux auth.log (using syslog) and sends the log data to Bridgecrew cloud in an encrypted secured manner.

## Linux Auth

The installation includes 2 steps:   
1. `auth.log` syslog configuration   
2. Installing the syslog integration docker 

## Architecture
![Integration architecture](../../docs/LinuxAuthArch.png)

### 1. Linux syslog configuration
1. Edit `sudo vi /etc/rsyslog.conf`
2. Add row: 
```sh 
auth,authpriv.* @[REPLACE_WITH_LOGSTASH_HOST]:9910
```

### 2. Install the syslog integration docker 
###### Port verification
The port 9910 (UDP) must be open between the to the logstash host (listening port).   
Verify that `iptables` is configured to allow incoming traffic on port 9910.

#### Installation

1. ssh into a server where the logstash-docker should be deployed
2. Install docker
3. Verify docker by running the following command: ``` docker info ```
4. Run syslog-integration docker by executing:
```sh
docker run -d -p 9910:9910/udp -e BC_CUSTOMER_NAME=[REPLACE_WITH_CUSTOMER_NAME] -e BC_API_TOKEN=[REPLACE_WITH_API_TOKEN] -e BC_URL="https://logstash.bridgecrew.cloud/logstash" bridgecrew/linux-auth-integration
```
