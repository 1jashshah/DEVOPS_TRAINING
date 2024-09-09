# Day 31 Task : Automation (IaaC) Terraform on AWS Assessment Project

## Project Overview
This capstone project is designed to assess participants' knowledge and practical skills with Terraform, specifically focusing on AWS. The project will require deploying a complete infrastructure using Terraform, emphasizing the usage of state lock, variables, .tfvars files, modules, functions, workspaces, and lifecycle rules. The deployment will be restricted to AWS Free Tier resources to avoid unnecessary costs.

## Project Objectives
 - Deploy a multi-tier architecture on AWS using Terraform.
 - Implement state locking to manage concurrent changes.
 - Use variables and .tfvars files to parameterize configurations.
 - Create and use Terraform modules to promote reusability and organization.
 - Utilize functions to dynamically configure resources.
 - Manage multiple environments using Terraform workspaces.
 - Implement lifecycle rules to control resource creation, updates, and deletion.

## Project Steps

 - ### Step 1: Setup Remote State and Locking
     - Create an S3 bucket for storing Terraform state.
     - Create a DynamoDB table for state locking.
    ![alt text](<img/Screenshot from 2024-08-23 15-08-35.png>) 
    ![alt text](<img/Screenshot from 2024-08-23 15-11-46.png>)
     - Configure the backend in Terraform to use the S3 bucket and DynamoDB table.
    ![alt text](<img/Screenshot from 2024-08-24 01-08-37.png>)

 - ### Step 2: Develop and Organize Modules
     - Develop separate modules for VPC, EC2, RDS, S3, and IAM.
     - Place each module in a separate directory with main.tf, variables.tf, and outputs.tf.
     ![alt text](<img/Screenshot from 2024-08-23 15-23-17.png>)

 - ### Step 3: Define Variables and tfvars Files
     - Define variables in variables.tf files within each module.
     ![alt text](<img/Screenshot from 2024-08-24 00-59-03.png>)
     - Create a terraform.tfvars file with default values.
     ![alt text](<img/Screenshot from 2024-08-24 01-03-28.png>)
     - Create separate environment-specific .tfvars files (e.g., dev.tfvars, prod.tfvars).
     ![alt text](<img/Screenshot from 2024-08-24 01-06-15.png>)


 - ### Step 4: Implement Workspaces
     - Initialize Terraform and create workspaces (development, staging, production).
     ![alt text](<img/Screenshot from 2024-08-24 01-07-47.png>)
     - Deploy infrastructure in each workspace using the appropriate .tfvars file.
     ![alt text](<img/Screenshot from 2024-08-24 01-12-54.png>)
     ![alt text](<img/Screenshot from 2024-08-24 01-11-41.png>) 
     ![alt text](<img/Screenshot from 2024-08-24 01-10-59.png>) 

 - ### Step 5: Deploy the Infrastructure
     - Use the terraform apply command to deploy the infrastructure in each workspace.
     ![alt text](<img/Screenshot from 2024-08-24 00-57-01.png>)
     - Verify the deployment by accessing the EC2 instances and ensuring the application is running.

 - ### Step 7: Cleanup
     - Destroy the infrastructure in each workspace using terraform destroy.
     - Ensure that resources marked with prevent_destroy are not deleted.
     ![alt text](<img/Screenshot from 2024-08-24 01-28-11.png>)

