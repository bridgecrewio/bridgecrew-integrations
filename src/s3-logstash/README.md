# S3-Logstash integration
This integration is designed to **pull** data from AWS S3, instead of receive log data through push events.


## Setup
### Customer's AWS account
1. Create a dedicated bucket for the logs, if one does not exist.
2. Create a cross account role, which is configured to have the account *890234264427* in it's trust policy / AssumeRole policy, and the following inline policy, replacing `name_of_the_bucket` with the name of the log bucket:
    ```json
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "s3:ListBucket"
          ],
          "Resource": [
            "arn:aws:s3:::name_of_the_bucket"
          ]
        },
        {
          "Effect": "Allow",
          "Action": [
            "s3:PutObject",
            "s3:GetObject"
          ],
          "Resource": [
            "arn:aws:s3:::name_of_the_bucket/*"
          ]
        }
      ]
    }
    ```

### Bridgecrew's AWS account
Launch the docker as described in [running the docker](#running-the-docker), locally or on as a service in our ECS

## Running the docker
```bash
$ docker run -e REGION=eu-west-1 -e BUCKET_NAME=<BUCKET_IN_CUSTOMER_ACCOUNT> -e ROLE_ARN=<ARN_OF_ROLE_IN_CUSTOMER_ACCOUNT> -e BC_URL=<BRIDGECREW_LOGSTASH_ENDPOINT> -e ES_URL=<CUSTOMER_DEDICATED_DOMAIN> -it bridgecrew/s3-logstash
```

Example:
```bash
$ docker run -e REGION=eu-west-1 -e BUCKET_NAME=bc-logstash-output -e ROLE_ARN=arn:aws:iam::123456123456:role/bc-s3-logs-role -e BC_URL=https://path.to.bridgecrew/logstah -e ES_URL=search-asdfjklasd.us-east-1.es.amazonaws.com -it bridgecrew/s3-logstash
```
