### **Project: Advanced Terraform with Provisioners, Modules, and Workspaces**

#### **Project Objective:**

This project is designed to evaluate participants\' understanding of
Terraform provisioners, modules, and workspaces. The project involves
deploying a basic infrastructure on AWS using Terraform modules,
executing remote commands on the provisioned resources using
provisioners, and managing multiple environments using Terraform
workspaces. All resources should be within the AWS Free Tier limits.

#### **Project Overview:**

Participants will create a Terraform configuration that deploys an EC2
instance and an S3 bucket using a custom Terraform module. The project
will also require the use of Terraform provisioners to execute scripts
on the EC2 instance. Finally, participants will manage separate
environments (e.g., dev and prod) using Terraform workspaces.

![](photos/media/image4.png)
![](photos/media/image2.png)

#### 

#### 

#### 

#### 

#### 

#### 

#### 

#### 

#### 

#### **Specifications:**

1.  **Terraform Modules**:

    -   Create a reusable module to deploy an EC2 instance and an S3
        > bucket.

    -   The EC2 instance should be of type t2.micro, and the S3 bucket
        > should be configured for standard storage.

    -   The module should accept input variables for the instance type,
        > AMI ID, key pair name, and bucket name.

    -   Outputs should include the EC2 instance's public IP and S3
        > bucket's ARN.

![](photos/media/image6.png)

![](photos/media/image9.png)

2.  **Terraform Provisioners**:

    -   Use remote-exec and local-exec provisioners to perform
        > post-deployment actions on the EC2 instance.

    -   The remote-exec provisioner should be used to connect to the EC2
        > instance via SSH and run a script that installs Apache HTTP
        > Server.

    -   The local-exec provisioner should be used to output a message on
        > the local machine indicating the deployment status, such as
        > \"EC2 instance successfully provisioned with Apache.\"

![](photos/media/image7.png)
3.  **Terraform Workspaces**:

    -   Implement Terraform workspaces to manage separate environments
        > (e.g., dev and prod).

    -   Each workspace should deploy the same infrastructure (EC2 and
        > S3) but with different configurations (e.g., different tags or
        > bucket names).

    -   Ensure that the state for each workspace is managed separately
        > to prevent conflicts between environments.

![](photos/media/image5.png)

#### **Key Tasks:**

1.  **Module Development**:

    -   **Module Setup**: Create a directory for the module (e.g.,
        > modules/aws_infrastructure).

    -   **Resource Definitions**: Define the resources for an EC2
        > instance and an S3 bucket within the module.

![](photos/media/image1.png)

![](photos/media/image8.png)

-   **Variable Inputs**: Define input variables for instance type, AMI
    > ID, key pair name, and S3 bucket name.

-   **Outputs**: Define outputs for the EC2 instance\'s public IP and
    > the S3 bucket\'s ARN.

2.  **Main Terraform Configuration**:

    -   **Main Config Setup**: In the root directory, create a Terraform
        > configuration that calls the custom module.

    -   **Backend Configuration**: Configure Terraform to use local
        > state storage for simplicity (optional for Free Tier
        > compliance).

3.  **Provisioner Implementation**:

    -   **Remote Execution**: Use the remote-exec provisioner to SSH
        > into the EC2 instance and execute a script that installs
        > Apache.

    -   **Local Execution**: Use the local-exec provisioner to print a
        > confirmation message on the local machine after successful
        > deployment.

4.  **Workspace Management**:

    -   **Workspace Creation**: Create Terraform workspaces for dev and
        > prod.

> ![](photos/media/image3.png)

-   **Environment-Specific Configurations**: Customize the EC2 instance
    > tags and S3 bucket names for each workspace to differentiate
    > between environments.

-   **Workspace Deployment**: Deploy the infrastructure separately in
    > the dev and prod workspaces.
