# íº€ Terraform AWS EC2 Lab

A hands-on Infrastructure as Code (IaC) project using Terraform to deploy and manage AWS EC2 instances.

## í³‹ Project Overview

This project demonstrates real-world Terraform skills by provisioning AWS infrastructure from scratch using code â€” no manual clicking in the console.

## í» ï¸ Technologies Used

- Terraform v1.x
- AWS EC2
- AWS CLI
- Git & GitHub

## í³ Project Structure

terraform-aws-ec2-lab/
â”œâ”€â”€ main.tf          # Main infrastructure code
â”œâ”€â”€ variables.tf     # Input variables
â”œâ”€â”€ outputs.tf       # Output values
â”œâ”€â”€ .gitignore       # Ignore sensitive files
â””â”€â”€ README.md        # Project documentation

## âš™ï¸ What This Deploys

- EC2 instance (t2.micro) in us-east-1
- Tagged and ready for production use

## íº€ How to Use

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

## í³¸ Proof It Worked

![EC2 Running](screenshots/ec2-running.png)

## í·  What I Learned

- Writing Terraform providers and resources
- AWS infrastructure provisioning with IaC
- Terraform workflow: init â†’ plan â†’ apply â†’ destroy
- Version control for infrastructure code

## í³ˆ Coming Next

- Lab 2: Variables & Outputs
- Lab 3: Remote State with S3
- Lab 4: VPC & Security Groups
- Lab 5: Terraform Modules

## í±¨â€í²» Author

**Thierno**
[GitHub](https://github.com/Thierno5) | [LinkedIn](#)
