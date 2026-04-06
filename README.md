# Terraform AWS EC2 Lab

Infrastructure as Code project using Terraform to provision and manage AWS EC2 instances. Built as Lab 1 of a 5-part Terraform series.

---

## Technologies Used

- Terraform v1.x
- Amazon Web Services (EC2)
- AWS CLI
- Git & GitHub
- VS Code

---

## Project Structure

    terraform-aws-ec2-lab/
    ├── main.tf                  
    ├── variables.tf             
    ├── outputs.tf               
    ├── .terraform.lock.hcl      
    ├── .gitignore               
    ├── screenshots/             
    └── README.md                

---

## Infrastructure Deployed

- EC2 instance (t2.micro) in us-east-1b
- Amazon Linux AMI
- Tagged as TerraformLab
- Public IP assigned automatically

---

## Process & Commands

### 1. Project Setup
Created all required Terraform project files.

### 2. Write Terraform Code
Defined the AWS provider and EC2 resource in main.tf with instance type, AMI, and tags. Declared input variables in variables.tf and output values in outputs.tf.

### 3. Configure AWS Credentials
Configured the AWS CLI with access keys, region, and output format. Verified authentication using the AWS STS service.

### 4. Initialize Terraform
Ran terraform init to download the AWS provider plugin and prepare the working directory.

### 5. Plan Infrastructure
Ran terraform plan to preview all changes before applying. Confirmed 1 resource to be created with no unexpected changes.

### 6. Apply — Deploy to AWS
Ran terraform apply and confirmed with yes. Terraform provisioned the EC2 instance in approximately 30 seconds.

### 7. Verify in AWS Console
Confirmed the instance was running in the AWS EC2 console with the correct name, type, region, and a live public IP address.

### 8. Destroy Infrastructure
Ran terraform destroy to cleanly remove all provisioned resources and avoid unnecessary AWS charges.

### 9. Version Control
Initialized a local Git repository, committed all project files, and pushed to GitHub with a descriptive commit message.

---

## Proof of Deployment

![EC2 Running](screenshots/ec2-running.png)

---

## Key Takeaways

- Writing Terraform providers and resources from scratch
- Understanding the full IaC workflow: init, plan, apply, destroy
- Provisioning real cloud infrastructure without manual console interaction
- Managing infrastructure code with Git version control

---

## Coming Next

- Lab 2: Variables and Outputs
- Lab 3: Remote State with S3
- Lab 4: VPC and Security Groups
- Lab 5: Terraform Modules

---

## Author

**Thierno Balde**
[GitHub](https://github.com/Thierno5) | [LinkedIn](https://www.linkedin.com/in/thierno-balde-951332246)