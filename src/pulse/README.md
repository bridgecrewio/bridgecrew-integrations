# Docker-Pulse Secure-Integration
The docker contains a running Logstash agent. The docker is collecting data from [Pulse Secure Virtual Traffic Manager](https://www.pulsesecure.net/) (using syslog) and sends the log data to Bridgecrew cloud in an encrypted secured manner.

## Pulse Secure
 Two parts for installation:
 1) Configuring the Traffic Manager to Export Data to Logstash
 2) Installing the Pulse Secure integration docker 
 
 
 ### 1. Pulse Secure Traffic Manager syslog configuration
 Enter to [guide](https://www-prev.pulsesecure.net/download/techpubs/current/1416/Pulse-vADC-Solutions/Pulse-Virtual-Traffic-Manager/18.2/DeploymentGuide_vTM-ElasticStack.pdf) page 7-8 and follow after the instructions.
    
#### Transaction Metadata  
**transaction_export!endpoint:** IP_SERVER_DOCKER:PORT (For example -localhost:9910)  
**transaction_export!tls:**  No  
**transaction_export!enabled:** Yes    

#### Log Files
**log_export!endpoint:** IP_SERVER_DOCKER:PORT (For example -localhost:9910)
**log_export!enabled:** Yes