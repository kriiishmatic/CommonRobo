#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-05e5bd14656ebdaf3"   # replace with your actual Security Group ID
ZONE_ID="Z0212707MY585LOOEFGA" # replace with your Hosted Zone ID
DOMAIN_NAME="kriiishmatic.fun"

# Loop through instances passed as arguments (e.g., mongodb redis mysql frontend)
for instance in "$@"
do
    # Launch instance
    INSTANCE_ID=$(aws ec2 run-instances \
        --image-id "$AMI_ID" \
        --instance-type t3.micro \
        --security-group-ids "$SG_ID" \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
        --query 'Instances[0].InstanceId' \
        --output text)

    # Get IP (private for backend, public for frontend)
    if [ "$instance" != "frontend" ]; then
        IP=$(aws ec2 describe-instances \
            --instance-ids "$INSTANCE_ID" \
            --query 'Reservations[0].Instances[0].PrivateIpAddress' \
            --output text)
        RECORD_NAME="$instance.$DOMAIN_NAME"
    else
        IP=$(aws ec2 describe-instances \
            --instance-ids "$INSTANCE_ID" \
            --query 'Reservations[0].Instances[0].PublicIpAddress' \
            --output text)
        RECORD_NAME="$DOMAIN_NAME"
    fi

    echo "$instance: $IP"

    # Update DNS record in Route53
    aws route53 change-resource-record-sets \
        --hosted-zone-id "$ZONE_ID" \
        --change-batch "{
            \"Comment\": \"Updating record set\",
            \"Changes\": [{
                \"Action\": \"UPSERT\",
                \"ResourceRecordSet\": {
                    \"Name\": \"$RECORD_NAME\",
                    \"Type\": \"A\",
                    \"TTL\": 1,
                    \"ResourceRecords\": [{
                        \"Value\": \"$IP\"
                    }]
                }
            }]
        }"
done
