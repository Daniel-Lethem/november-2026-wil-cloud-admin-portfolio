Choice and Scope
• Choice Made: Track A - Bash script
• Current Status: Checking AWS resources, resource tags, security groups and cloud compliance in the AWS web console is time-consuming and tedious.
• Friction: Valuable engineering time is spent clicking through multiple web console pages to validate resource hygiene and create reports manually before submissions.
• Desired Status: A bash script should be created to automate this task by executing programmatic checks, securely archiving evidence found in the private S3 vault and creates local logs that are structured with timestamps.
• Methodology: A customized Bash script that uses AWS’s CLI which pairs with an automated upload to the S3 vault.
• Success Criteria: A full resource audit is successfully executed and forms a clean log file while also uploading the evidence to the private S3 vault with no human intervention.

AWS Resource Audit and S3 Vault Archiver (AWS_Resources_Audit.sh)
•	Purpose
o	Track: Track A – Bash Automation
o	Friction eliminated: Manually accessing multiple AWS Management Console pages to validate the resource tags, create timestamped compliance reports and inspecting security groups as it is prone to errors and involves repetition.
o	Solution: A script that automates resource auditing via AWS’s CLI tool and outputs a well-structured timestamped log file which is securely uploaded to the private S3 vault using AES-256 server-side encryption.

•	Prerequisites
o	Environment: Windows using Git Bash or a Linux and macOS terminal window.
o	Tools Needed: AWS CLI v2, Git. Both require an installation and need to be added to the operating system’s environment variables such as PATH.
o	IAM permissions and Authentication: An active AWS CLI session with an authenticated IAM user that has permissions for s3:GetBucketTagging, ec2:DescribeSecurityGroups, s3:PutObject with s3:x-amz-server-side-encryption: AES256 header compliance.

•	How to Run
o	Open the Git Bash application and navigate to the script’s directory: cd /c/Users/<insert-username-here>/Downloads
o	Grant execution permissions during your first run only: chmod +x <script-name>.sh
o	Execute the resource auditing script: ./<script-name>.sh
o	Verify that the local timestamp .txt log file is present on your machine and access the AWS Management Console to verify that the upload is successfully added to the S3 vault under the 03-Ops-Automation folder.

•	Failure Modes
o	Expired Session Token: An expired AWS CLI session will not have a log file uploaded to the S3 vault which the script will notify the user of and exits cleanly. To rectify the problem, make sure to use the ‘aws login’ command to recover the upload.
o	Unencrypted Upload Rejection: The upload will not proceed if the targeted S3 vault has an enforced policy that blocks unencrypted uploads as the script passes the ‘--sse AES256’ flag with the ‘aws s3 cp’ command to satisfy the policy. If the policy is altered or omitted, then the S3 vault will reject the PutObject request, and the script will stop with exit code 1.
o	Missing Bucket Tags: If the bucket has no tags or ‘get-bucket-tagging’ fails then the script will log the error output in the log file and print ‘FAILED’ in the terminal window without crashing the security group check.

•	Cost Check and Resource Tagging
o	Cost Verification ($0.00 Always-On Spend): The tool runs locally on-demand using the AWS CLI and Bash and does not provision any compute resources such as EC2 or NAT Gateways which results in no recurring compute costs. The log files stored in the S3 vault are around 1.2KB in file size which falls within the AWS Free Tier Limits.
o	Tagging Compliance: Target and audited vault resources have the required governance tags attached such as Project=WIL-2026, Host=SipCloud.