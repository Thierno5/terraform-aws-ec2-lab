# Terraform AWS EC2 Lab Series

Production-grade Infrastructure as Code project using Terraform to provision
and manage AWS infrastructure. Built as a 5-part series replicating real
DevOps team workflows. Every lab builds on the previous one.

---

## Technologies Used

- Terraform v1.x
- Amazon Web Services (EC2, S3, DynamoDB)
- AWS CLI
- Git and GitHub
- VS Code

---

## Lab Series Progress

| Lab | Topic | Status |
|-----|-------|--------|
| Lab 1 | EC2 with Terraform | Complete |
| Lab 2 | Variables and Outputs | Complete |
| Lab 3 | Remote State with S3 and DynamoDB | Complete |
| Lab 4 | VPC and Security Groups | Coming soon |
| Lab 5 | Terraform Modules | Coming soon |

---

## Prerequisites

Before starting make sure you have:

- AWS account with IAM user and access keys
- Terraform installed
- AWS CLI installed and configured
- Git installed
- VS Code installed

Open your terminal and configure AWS credentials:

    aws configure

Enter when prompted:

    AWS Access Key ID:     your access key
    AWS Secret Access Key: your secret key
    Default region name:   us-east-1
    Default output format: json

Verify credentials:

    aws sts get-caller-identity

Fix IPv6 connectivity issue on Windows — run once:

    echo 'export GODEBUG=preferIPv4=1' >> ~/.bashrc
    source ~/.bashrc

---

## Lab 1 — EC2 with Terraform

### Goal
Deploy a real AWS EC2 instance using Terraform with no manual
console clicking.

### Step 1 — Create project folder and files

    mkdir terraform-aws-ec2-lab
    cd terraform-aws-ec2-lab
    touch main.tf variables.tf outputs.tf README.md .gitignore

### Step 2 — Edit main.tf

Open main.tf and paste:

    terraform {
      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "= 5.31.0"
        }
      }
    }

    provider "aws" {
      region = "us-east-1"
    }

    resource "aws_instance" "web" {
      ami           = "ami-0c02fb55956c7d316"
      instance_type = "t2.micro"

      tags = {
        Name = "TerraformLab"
      }
    }

### Step 3 — Edit variables.tf

Open variables.tf and paste:

    variable "instance_type" {
      default = "t2.micro"
    }

### Step 4 — Edit outputs.tf

Open outputs.tf and paste:

    output "instance_id" {
      value = aws_instance.web.id
    }

### Step 5 — Edit .gitignore

Open .gitignore and paste:

    .terraform/
    *.tfstate
    *.tfstate.backup

### Step 6 — Initialize Terraform

    GODEBUG=preferIPv4=1 terraform init

Expected output:

    Terraform has been successfully initialized!

### Step 7 — Preview changes

    terraform plan

Expected output:

    Plan: 1 to add, 0 to change, 0 to destroy.

### Step 8 — Deploy

    terraform apply

Type yes when prompted.

Expected output:

    Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

### Step 9 — Verify

Go to AWS Console → EC2 → Instances
You should see TerraformLab running with a public IP.

### Step 10 — Destroy

    terraform destroy

Type yes when prompted.

### Step 11 — Push to GitHub

    git init
    git add .
    git commit -m "Lab 1: Deploy EC2 instance with Terraform"
    git branch -M main
    git remote add origin https://github.com/YOUR_USERNAME/terraform-aws-ec2-lab.git
    git push -u origin main

### What you learn
- Terraform provider and resource blocks
- Full workflow: init, plan, apply, destroy
- How Terraform tracks infrastructure in state files

---

## Lab 2 — Variables and Outputs

### Goal
Refactor hardcoded values into input variables so the same codebase
works across dev, staging, and production environments.

### Step 1 — Create new branch

    git checkout -b lab-02-variables

### Step 2 — Edit variables.tf

Open variables.tf, select all and replace with:

    variable "instance_type" {
      description = "EC2 instance type"
      type        = string
      default     = "t2.micro"
    }

    variable "region" {
      description = "AWS region"
      type        = string
      default     = "us-east-1"
    }

    variable "instance_name" {
      description = "Name tag for the EC2 instance"
      type        = string
      default     = "TerraformLab-Dev"
    }

### Step 3 — Edit main.tf

Open main.tf, select all and replace with:

    terraform {
      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "= 5.31.0"
        }
      }
    }

    provider "aws" {
      region = var.region
    }

    resource "aws_instance" "web" {
      ami           = "ami-0c02fb55956c7d316"
      instance_type = var.instance_type

      tags = {
        Name = var.instance_name
      }
    }

### Step 4 — Edit outputs.tf

Open outputs.tf, select all and replace with:

    output "instance_id" {
      description = "The ID of the EC2 instance"
      value       = aws_instance.web.id
    }

    output "instance_public_ip" {
      description = "Public IP of the EC2 instance"
      value       = aws_instance.web.public_ip
    }

    output "instance_name" {
      description = "Name tag of the EC2 instance"
      value       = var.instance_name
    }

### Step 5 — Create terraform.tfvars

Create a new file:

    touch terraform.tfvars

Open terraform.tfvars and paste:

    instance_type = "t2.micro"
    region        = "us-east-1"
    instance_name = "TerraformLab-Dev"

### Step 6 — Initialize Terraform

    GODEBUG=preferIPv4=1 terraform init

### Step 7 — Preview changes

    terraform plan

Confirm you see values coming from variables:

    instance_type = "t2.micro"
    Name          = "TerraformLab-Dev"

### Step 8 — Deploy

    terraform apply

Type yes when prompted.

After apply you will see outputs printed automatically:

    Outputs:
    instance_id = "i-xxxxxxxxxxxxxxxxx"

### Step 9 — Destroy

    terraform destroy

Type yes when prompted.

### Step 10 — Push to GitHub

    git add .
    git commit -m "Lab 2: Variables, outputs and reusable code"
    git push origin lab-02-variables

Then open the pull request link and merge into main.

### What you learn
- Input variables with types and descriptions
- terraform.tfvars for environment-specific values
- Output values printed after apply
- How to make one codebase work across multiple environments

---

## Lab 3 — Remote State with S3 and DynamoDB

### Goal
Move Terraform state from your local machine to AWS S3 so multiple
engineers can collaborate without state conflicts.

### The problem this solves

In Labs 1 and 2 state lived on the local machine. In a team
environment two engineers applying at the same time would corrupt
the state file. Lab 3 moves state to S3 so every engineer reads
from the same source of truth. DynamoDB locks the state during
operations so no two applies can run simultaneously.

### Step 1 — Create new branch

    git checkout -b lab-03-remote-state

### Step 2 — Create setup.tf

Create a new file:

    touch setup.tf

Open setup.tf and paste:

    resource "aws_s3_bucket" "terraform_state" {
      bucket = "terraform-state-YOUR_NAME-lab"

      lifecycle {
        prevent_destroy = true
      }

      tags = {
        Name = "Terraform State Bucket"
      }
    }

    resource "aws_s3_bucket_versioning" "state_versioning" {
      bucket = aws_s3_bucket.terraform_state.id

      versioning_configuration {
        status = "Enabled"
      }
    }

    resource "aws_s3_bucket_server_side_encryption_configuration" "state_encryption" {
      bucket = aws_s3_bucket.terraform_state.id

      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = "AES256"
        }
      }
    }

    resource "aws_dynamodb_table" "terraform_lock" {
      name         = "terraform-state-lock"
      billing_mode = "PAY_PER_REQUEST"
      hash_key     = "LockID"

      attribute {
        name = "LockID"
        type = "S"
      }

      tags = {
        Name = "Terraform State Lock"
      }
    }

Note: Replace YOUR_NAME in the bucket name with your own name.
S3 bucket names must be globally unique across all AWS accounts.

### Step 3 — Create backend.tf

Create a new file:

    touch backend.tf

Open backend.tf and paste:

    terraform {
      backend "s3" {
        bucket         = "terraform-state-YOUR_NAME-lab"
        key            = "lab03/terraform.tfstate"
        region         = "us-east-1"
        dynamodb_table = "terraform-state-lock"
        encrypt        = true
      }
    }

Note: Replace YOUR_NAME with the same name you used in setup.tf.

### Step 4 — Edit outputs.tf

Open outputs.tf and add these two outputs at the bottom:

    output "s3_bucket_name" {
      description = "S3 bucket storing Terraform state"
      value       = aws_s3_bucket.terraform_state.bucket
    }

    output "dynamodb_table_name" {
      description = "DynamoDB table for state locking"
      value       = aws_dynamodb_table.terraform_lock.name
    }

### Step 5 — Initialize Terraform

    GODEBUG=preferIPv4=1 terraform init -plugin-dir=.terraform/providers

### Step 6 — Deploy S3 and DynamoDB

    terraform apply

Type yes when prompted.

After apply verify in AWS Console:
- S3 → Buckets → terraform-state-YOUR_NAME-lab exists
- DynamoDB → Tables → terraform-state-lock exists

### Step 7 — Migrate state to S3

    GODEBUG=preferIPv4=1 terraform init -plugin-dir=.terraform/providers -migrate-state

Type yes when prompted.

Expected output:

    Successfully configured the backend "s3"!

Verify in AWS Console:
S3 → terraform-state-YOUR_NAME-lab → lab03 → terraform.tfstate

Your state file is now in the cloud.

### Step 8 — Destroy EC2 only

The S3 bucket has prevent_destroy set so it cannot be accidentally
deleted. Destroy only the EC2 instance:

    terraform destroy -target=aws_instance.web

Type yes when prompted.

### Step 9 — Push to GitHub

    git add .
    git commit -m "Lab 3: Remote state with S3 and DynamoDB"
    git push origin lab-03-remote-state

Then open the pull request link and merge into main.

### What you learn
- Remote state storage in S3
- State locking with DynamoDB
- Backend configuration and state migration
- prevent_destroy to protect critical resources
- How real DevOps teams share infrastructure state

---

## Project Structure

    terraform-aws-ec2-lab/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── terraform.tfvars
    ├── backend.tf
    ├── setup.tf
    ├── .terraform.lock.hcl
    ├── .gitignore
    ├── screenshots/
    └── README.md

---

## Screenshots
### Lab 1 — EC2 Running
![EC2 Running Lab 1](screenshots/ec2-running.png)

### Lab 2 — Variables and Outputs
![EC2 Variables Lab 2](screenshots/ec2-variables%20.png)
![EC2 Lab 2 Output](screenshots/ec2-lab2.png)
![EC2 Lab 2 Terminal Output](screenshots/ec2.lab2-output.png)

### Lab 3 — Remote State
![Lab 3 EC2](screenshots/lab3-ec2.png)
![Lab 3 S3 Bucket](screenshots/lab3-s3-buckets.png)
![Lab 3 DynamoDB](screenshots/lab3-dynamoDB.png)
## Key Takeaways

- Never hardcode values in Terraform — use variables
- Always run plan before apply — no surprises in production
- Remote state is mandatory for team environments
- State locking prevents concurrent apply conflicts
- prevent_destroy protects critical resources from accidental deletion
- Branch per lab keeps history clean and reviewable

---

## Author

**Thierno Balde**
[GitHub](https://github.com/Thierno5) | [LinkedIn](https://www.linkedin.com/in/thierno-balde-951332246)
