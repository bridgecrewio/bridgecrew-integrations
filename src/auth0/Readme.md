# Auth0 Integration

To configure auth0 to send logs to bridgecrew there is nothing to deploy in a customer account.  Just update auth0 as described here: 
https://auth0.com/docs/extensions/logstash

In particular, configure the logstash extension in auth0 as follows:
```
logstash_url=https://logstash.bridgecrew.cloud/logstash/<CUSTOMER_NAME>/auth0
logstash_user=<CUSTOMER_NAME>
logstash_index=auth0
logstash_password=<YOUR_LOGSTASH_PASSWORD>
slack_incoming_webhook=<YOUR_SLACK_WEBHOOK>
slack_send_success=yes
```
