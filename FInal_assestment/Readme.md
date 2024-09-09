### **Final Assessment Task:**

In this task, I have succesfully deployed a modular e-commerce
application using AWS services and DevOps tools. The tools I used for
this project are:

1\. AWS

2\. Terraform

3\. Docker

4\. Jenkins

5\. GitHub

6\. Ansible

7\. K8S

8\. Helm Chart

So, first of all, I created terraform files to create below resources on
AWS:

1\. VPC

2\. Security Groups

3\. IAM Role

4\. EC2 Instance (X3)

5\. S3 Bucket

When, the resources were successfully created on AWS, I created an
e-commerce application using CSS/HTML.

I dockerized the code and pushed the image to Docker hub using Jenkins
pipeline with groovy language which was fetching the code from the
GitHub.

.

├── main.tf

├── variables.tf

└── vpc

\| ├── main.tf

\| ├── outputs.tf

\| └── variables.tf

├── sg

│ ├── main.tf

│ ├── outputs.tf

│ └── variables.tf

├── iam

│ ├── main.tf

│ ├── outputs.tf

│ └── variables.tf

├── ec2

│ ├── main.tf

│ └── variables.tf

├── s3

├── main.tf

└── variables.tf

The Screenshots for final assessment AWS Management system.

![alt
text](photos/media/image10.png)

![alt
text](photos/media/image1.png)

![alt
text](photos/media/image3.png)

![alt
text](photos/media/image6.png)

![alt
text](photos/media/image9.png)

![alt
text](photos/media/image11.png)

![alt
text](photos/media/image2.png)

![alt
text](photos/media/image5.png)

![alt
text](photos/media/image8.png)

![alt
text](photos/media/image4.png)

![alt
text](photos/media/image7.png)

### **jenkins pipeiline:-**

pipeline {

agent any

environment {

// DockerHub credentials

DOCKER_CREDENTIALS_ID = \'j\*\*\*\*\*/1212\'

// DockerHub repository

DOCKER_REPO = \'1jashshah/simple-web-app\'

// GitHub credentials

GIT_CREDENTIALS_ID = \'gtk0\'

// Kubernetes context (e.g., minikube, eks)

KUBE_CONTEXT = \'your-kubernetes-context\'

// Helm release name

HELM_RELEASE = \'simple-web-app-release\'

// Kubernetes namespace

KUBE_NAMESPACE = \'default\'

}

stages {

stage(\'Clone Repository\') {

steps {

git credentialsId: \"\${GIT_CREDENTIALS_ID}\", url:
\'https://github.com/bha1212002/d-38-jenkins.git\', branch: \'main\'

}

}

stage(\'Build Docker Image\') {

steps {

script {

// Build the Docker image and tag it with BUILD_ID

def image = docker.build(\"\${DOCKER_REPO}:\${env.BUILD_ID}\", \"-f
Dockerfile ./app\")

}

}

}

stage(\'Push Docker Image\') {

steps {

script {

// Push the image with both the BUILD_ID tag and the \'latest\' tag

docker.withRegistry(\'https://index.docker.io/v1/\',
\"\${DOCKER_CREDENTIALS_ID}\") {

def image = docker.image(\"\${DOCKER_REPO}:\${env.BUILD_ID}\")

image.push(\"\${env.BUILD_ID}\") // Push with BUILD_ID tag

image.push(\'latest\') // Optionally, also push with \'latest\' tag

}

}

}

}

stage(\'Deploy to Kubernetes\') {

steps {

script {

// Use Helm to deploy the Docker image to Kubernetes

withKubeConfig(\[credentialsId: \'kubeconfig-id\', contextName:
\"\${KUBE_CONTEXT}\"\]) {

sh \"\"\"

helm upgrade \--install \${HELM_RELEASE} ./helm-chart \\

\--set image.repository=\${DOCKER_REPO} \\

\--set image.tag=\${env.BUILD_ID} \\

\--namespace \${KUBE_NAMESPACE}

\"\"\"

}

}

}

}

}

post {

always {

cleanWs()

}

}

}

#### **terraform**

#### **main.tf**

provider \"aws\" {

region = \"us-east-2\"

access_key = var.aws_access_key

secret_key = var.aws_secret_key

}

module \"vpc\" {

source = \"./vpc\"

vpc_cidr_block = \"10.0.0.0/16\"

subnet_cidr_blocks = \[\"10.0.1.0/24\", \"10.0.2.0/24\"\]

availability_zones = \[\"us-east-1a\", \"us-east-1b\"\]

}

module \"sg\" {

source = \"./sg\"

vpc_id = module.vpc.vpc_id

}

module \"iam\" {

source = \"./iam\"

}

module \"ec2\" {

source = \"./ec2\"

ami_id = \"ami-085f9c64a9b75eed5\"

instance_type = \"t2.micro\"

node_count = 2

subnet_id = module.vpc.subnet_ids\[0\]

security_group_id = module.sg.security_group_id

instance_profile_name = module.iam.instance_profile_name

}

module \"s3\" {

source = \"./s3\"

bucket_name = \"staticassetsbucket\"

}

#### **variables.tf**

variable \"aws_access_key\" {

description = \"AWS Access Key\"

type = string

}

variable \"aws_secret_key\" {

description = \"AWS Secret Key\"

type = string

}
