# 🚀 Terraform AWS EC2 Lab

A hands-on Infrastructure as Code (IaC) project using Terraform to deploy and manage AWS EC2 instances.

## 📋 Project Overview

This project demonstrates real-world Terraform skills by provisioning AWS infrastructure from scratch using code — no manual clicking in the console.

## 🛠️ Technologies Used

- Terraform v1.x
- AWS EC2
- AWS CLI
- Git & GitHub

## 📁 Project Structure

terraform-aws-ec2-lab/
├── main.tf          # Main infrastructure code
├── variables.tf     # Input variables
├── outputs.tf       # Output values
├── .gitignore       # Ignore sensitive files
└── README.md        # Project documentation

## ⚙️ What This Deploys

- EC2 instance (t2.micro) in us-east-1
- Tagged and ready for production use

## 🚀 How to Use

### Prerequisites
- Terraform installed
- AWS CLI configured
- AWS account with IAM credentials

### Steps

1. Clone the repo
   git clone https://github.com/Thierno5/terraform-aws-ec2-lab.git
   cd terraform-aws-ec2-lab

2. Initialize Terraform
   terraform init

3. Preview changes
   terraform plan

4. Deploy infrastructure
   terraform apply

5. Destroy when done
   terraform destroy

## 📸 Proof It Worked

![EC2 Running](screenshots/ec2-running.png)

## 🧠 What I Learned

- Writing Terraform providers and resources
- AWS infrastructure provisioning with IaC
- Terraform workflow: init → plan → apply → destroy
- Version control for infrastructure code

## 📈 Coming Next

- Lab 2: Variables & Outputs
- Lab 3: Remote State with S3
- Lab 4: VPC & Security Groups
- Lab 5: Terraform Modules

## 👨‍💻 Author

**Thierno**
[GitHub](https://github.com/Thierno5) | [LinkedIn]( [LinkedIn](https://www.linkedin.com/in/thierno-balde-951332246)