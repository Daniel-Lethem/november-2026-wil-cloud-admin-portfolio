#!/bin/bash

# Configuration
BUCKET_NAME="wil-daniellethem-datavault-2026"
REGION="af-south-1"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
LOG_FILE="account-health-$TIMESTAMP.txt"

echo "=== Starting AWS Resource Audit ($TIMESTAMP) ===" | tee "$LOG_FILE"

# 1. Check tags on your S3 Data Vault
echo -n "Checking S3 Vault tags for $BUCKET_NAME... " | tee -a "$LOG_FILE"
aws s3api get-bucket-tagging \
    --bucket "$BUCKET_NAME" \
    --output table >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    echo "SUCCESS"
else
    echo "FAILED"
fi

# 2. Append Security Group audit
echo -n "Auditing Security Groups... " | tee -a "$LOG_FILE"
aws ec2 describe-security-groups \
    --region "$REGION" \
    --filters "Name=group-name,Values=*edge-sg*" \
    --query "SecurityGroups[*].[GroupId, GroupName, Description]" \
    --output table >> "$LOG_FILE" 2>&1

echo "=== Audit Complete. Log saved to $LOG_FILE ===" | tee -a "$LOG_FILE"

# 3. Upload evidence log to your S3 Vault with encryption enforcement
echo "Uploading evidence report to S3 vault s3://$BUCKET_NAME/03-Ops-Automation/..."
aws s3 cp "$LOG_FILE" "s3://$BUCKET_NAME/03-Ops-Automation/$LOG_FILE" --region "$REGION" --sse AES256

if [ $? -eq 0 ]; then
    echo "Upload to S3 vault successful!"
else
    echo "Error: Failed to upload log to S3 vault." >&2
    exit 1
fi