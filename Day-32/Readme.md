**1. Setup Terraform Configuration\
1.1. Providers and Variables\
**Create a file main.tf to define the AWS provider and necessary
variables.\
\
provider \"aws\" {

region = \"us-west-2\"

}

variable \"ami_id\" {

default = \"ami-0aff18ec83b712f05\"

}

variable \"db_password\" {

type = string

sensitive = true

}\
\
**1.2. VPC Networking\
**Create a file vpc.tf to set up the VPC, subnets.\
\
\# VPC

resource \"aws_vpc\" \"jash_vpc\" {

cidr_block = \"10.0.0.0/16\"

enable_dns_support = true

enable_dns_hostnames = true

tags = {

Name = \"jash_vpc\"

}

}

\# Public Subnets

resource \"aws_subnet\" \"public_subnet_a\" {

vpc_id = aws_vpc.jash_vpc.id

cidr_block = \"10.0.1.0/24\"

availability_zone = \"us-west-2a\"

map_public_ip_on_launch = true

tags = {

Name = \"jash_public_subnet_a\"

}

}

resource \"aws_subnet\" \"public_subnet_b\" {

vpc_id = aws_vpc.jash_vpc.id

cidr_block = \"10.0.3.0/24\"

availability_zone = \"us-west-2b\"

map_public_ip_on_launch = true

tags = {

Name = \"jash_public_subnet_b\"

}

}

\# Private Subnets

resource \"aws_subnet\" \"private_subnet_a\" {

vpc_id = aws_vpc.jash_vpc.id

cidr_block = \"10.0.2.0/24\"

availability_zone = \"us-west-2a\"

tags = {

Name = \"jash_private_subnet_a\"

}

}

resource \"aws_subnet\" \"private_subnet_b\" {

vpc_id = aws_vpc.jash_vpc.id

cidr_block = \"10.0.4.0/24\"

availability_zone = \"us-west-2b\"

tags = {

Name = \"jash_private_subnet_b\"

}

}

\# Internet Gateway

resource \"aws_internet_gateway\" \"jash_igw\" {

vpc_id = aws_vpc.jash_vpc.id

tags = {

Name = \"jash_igw\"

}

}

\# Route Table for Public Subnets

resource \"aws_route_table\" \"public_rt\" {

vpc_id = aws_vpc.jash_vpc.id

route {

cidr_block = \"0.0.0.0/0\"

gateway_id = aws_internet_gateway.jash_igw.id

}

tags = {

Name = \"public_rt\"

}

}

\# Elastic IP for NAT Gateway

resource \"aws_eip\" \"nat_eip\" {

tags = {

Name = \"nat-eip\"

}

}

\# NAT Gateway

resource \"aws_nat_gateway\" \"nat_gateway\" {

allocation_id = aws_eip.nat_eip.id

subnet_id = aws_subnet.public_subnet_a.id \# NAT Gateway should be in a
public subnet

tags = {

Name = \"nat-gateway\"

}

}

\# Route Table for Private Subnets

resource \"aws_route_table\" \"private_rt\" {

vpc_id = aws_vpc.jash_vpc.id

route {

cidr_block = \"0.0.0.0/0\"

nat_gateway_id = aws_nat_gateway.nat_gateway.id

}

tags = {

Name = \"private_rt\"

}

}

\# Associate Public Subnets with Route Table

resource \"aws_route_table_association\"
\"public_subnet_a\_association\" {

subnet_id = aws_subnet.public_subnet_a.id

route_table_id = aws_route_table.public_rt.id

}

resource \"aws_route_table_association\"
\"public_subnet_b\_association\" {

subnet_id = aws_subnet.public_subnet_b.id

route_table_id = aws_route_table.public_rt.id

}

\# Associate Private Subnets with Route Table

resource \"aws_route_table_association\"
\"private_subnet_a\_association\" {

subnet_id = aws_subnet.private_subnet_a.id

route_table_id = aws_route_table.private_rt.id

}

resource \"aws_route_table_association\"
\"private_subnet_b\_association\" {

subnet_id = aws_subnet.private_subnet_b.id

route_table_id = aws_route_table.private_rt.id

}\
\
**Security Groups\
**security_groups.tf\
\
\# Security Group for Frontend Service

resource \"aws_security_group\" \"frontend_sg\" {

vpc_id = aws_vpc.jash_vpc.id

ingress {

from_port = 80

to_port = 80

protocol = \"tcp\"

cidr_blocks = \[\"0.0.0.0/0\"\]

}

egress {

from_port = 0

to_port = 0

protocol = \"-1\"

cidr_blocks = \[\"0.0.0.0/0\"\]

}

tags = {

Name = \"frontend_sg\"

}

}

\# Security Group for Backend Service

resource \"aws_security_group\" \"backend_sg\" {

vpc_id = aws_vpc.jash_vpc.id

ingress {

from_port = 5000

to_port = 5000

protocol = \"tcp\"

security_groups = \[aws_security_group.frontend_sg.id\]

}

egress {

from_port = 0

to_port = 0

protocol = \"-1\"

cidr_blocks = \[\"0.0.0.0/0\"\]

}

tags = {

Name = \"backend_sg\"

}

}

\# Security Group for RDS

resource \"aws_security_group\" \"db_sg\" {

vpc_id = aws_vpc.jash_vpc.id

ingress {

from_port = 3306

to_port = 3306

protocol = \"tcp\"

security_groups = \[aws_security_group.backend_sg.id\]

}

egress {

from_port = 0

to_port = 0

protocol = \"-1\"

cidr_blocks = \[\"0.0.0.0/0\"\]

}

tags = {

Name = \"db_sg\"

}

}\
\
**1.3. RDS Instance\
**Create a file rds.tf to configure the RDS instance.\
\
resource \"aws_db_subnet_group\" \"jash_db_subnet_group\" {

name = \"jash-db-subnet-group\"

subnet_ids = \[aws_subnet.private_subnet_a.id,
aws_subnet.private_subnet_b.id\]

tags = {

Name = \"jash-db-subnet-group\"

}

}

resource \"aws_db_instance\" \"jash_rds\" {

identifier = \"jash-rds\"

engine = \"mysql\"

instance_class = \"db.t3.micro\"

allocated_storage = 20

username = \"admin\"

password = var.db_password

db_subnet_group_name = aws_db_subnet_group.jash_db_subnet_group.name

vpc_security_group_ids = \[aws_security_group.db_sg.id\]

skip_final_snapshot = true

tags = {

Name = \"jash-rds\"

}

}

**1.4. ECS Cluster and Services\
**Create a file ecs.tf to set up the ECS Cluster, Task Definitions, and
Services.\
\
resource \"aws_ecs_cluster\" \"jash_ecs_cluster\" {

name = \"jash_ecs_cluster\"

}

resource \"aws_ecs_task_definition\" \"frontend_task\" {

family = \"frontend\"

network_mode = \"awsvpc\"

requires_compatibilities = \[\"FARGATE\"\]

cpu = \"256\"

memory = \"512\"

container_definitions = jsonencode(\[{

name = \"frontend\"

image = \"nginx:latest\"

cpu = 256

memory = 512

essential = true

portMappings = \[

{

containerPort = 80

hostPort = 80

}

\]

}\])

}

resource \"aws_ecs_task_definition\" \"backend_task\" {

family = \"backend\"

network_mode = \"awsvpc\"

requires_compatibilities = \[\"FARGATE\"\]

cpu = \"256\"

memory = \"512\"

execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

container_definitions = jsonencode(\[{

name = \"backend\"

image = \"python:3.9-slim\"

cpu = 256

memory = 512

essential = true

portMappings = \[

{

containerPort = 5000

hostPort = 5000

}

\]

environment = \[

{

name = \"DATABASE_URL\"

value =
\"jdbc:mysql://\${aws_db_instance.jash_rds.endpoint}:\${aws_db_instance.jash_rds.port}/mydb\"

}

\]

secrets = \[

{

name = \"DB_PASSWORD\"

valueFrom = aws_secretsmanager_secret.jash_db_secret.arn

}

\]

}\])

}

resource \"aws_ecs_service\" \"frontend_service\" {

name = \"frontend_service\"

cluster = aws_ecs_cluster.jash_ecs_cluster.id

task_definition = aws_ecs_task_definition.frontend_task.arn

desired_count = 1

launch_type = \"FARGATE\"

network_configuration {

subnets = \[aws_subnet.public_subnet_a.id,
aws_subnet.public_subnet_b.id\]

security_groups = \[aws_security_group.frontend_sg.id\]

assign_public_ip = true

}

}

resource \"aws_ecs_service\" \"backend_service\" {

name = \"backend_service\"

cluster = aws_ecs_cluster.jash_ecs_cluster.id

task_definition = aws_ecs_task_definition.backend_task.arn

desired_count = 1

launch_type = \"FARGATE\"

network_configuration {

subnets = \[aws_subnet.private_subnet_a.id,
aws_subnet.private_subnet_b.id\]

security_groups = \[aws_security_group.backend_sg.id\]

assign_public_ip = false

}

}

**1.5. Secrets Management\
**Create a file secrets.tf to manage secrets.\
\
resource \"aws_secretsmanager_secret\" \"jash_db_secret\" {

name = \"jash_db_secret3\"

}

resource \"aws_secretsmanager_secret_version\"
\"jash_db_secret_version\" {

secret_id = aws_secretsmanager_secret.jash_db_secret.id

secret_string = jsonencode({

password = var.db_password

})

}\
\
**1.6. Auto-Scaling Policies\
**Create a file autoscaling.tf for auto-scaling policies.\
\
resource \"aws_appautoscaling_target\" \"frontend_scaling_target\" {

max_capacity = 2

min_capacity = 1

resource_id =
\"service/\${aws_ecs_cluster.jash_ecs_cluster.name}/\${aws_ecs_service.frontend_service.name}\"

scalable_dimension = \"ecs:service:DesiredCount\"

service_namespace = \"ecs\"

}

resource \"aws_appautoscaling_policy\" \"frontend_scale_out\" {

name = \"frontend_scale_out\"

policy_type = \"StepScaling\"

resource_id =
aws_appautoscaling_target.frontend_scaling_target.resource_id

scalable_dimension =
aws_appautoscaling_target.frontend_scaling_target.scalable_dimension

service_namespace =
aws_appautoscaling_target.frontend_scaling_target.service_namespace

step_scaling_policy_configuration {

adjustment_type = \"ChangeInCapacity\"

cooldown = 300

metric_aggregation_type = \"Maximum\"

step_adjustment {

metric_interval_lower_bound = 0

scaling_adjustment = 1

}

}

}

resource \"aws_appautoscaling_policy\" \"frontend_scale_in\" {

name = \"frontend_scale_in\"

policy_type = \"StepScaling\"

resource_id =
aws_appautoscaling_target.frontend_scaling_target.resource_id

scalable_dimension =
aws_appautoscaling_target.frontend_scaling_target.scalable_dimension

service_namespace =
aws_appautoscaling_target.frontend_scaling_target.service_namespace

step_scaling_policy_configuration {

adjustment_type = \"ChangeInCapacity\"

cooldown = 300

metric_aggregation_type = \"Maximum\"

step_adjustment {

metric_interval_upper_bound = 0

scaling_adjustment = -1

}

}

}

iam.tf\
\
\# IAM Role for ECS Task Execution

resource \"aws_iam_role\" \"ecs_task_execution_role\" {

name = \"ecsTaskExecutionRole\"

assume_role_policy = jsonencode({

Version = \"2012-10-17\",

Statement = \[

{

Action = \"sts:AssumeRole\",

Effect = \"Allow\",

Principal = {

Service = \"ecs-tasks.amazonaws.com\"

}

}

\]

})

tags = {

Name = \"ecsTaskExecutionRole\"

}

}

\# Attach the Amazon ECS Task Execution IAM Policy to the Role

resource \"aws_iam_role_policy_attachment\"
\"ecs_task_execution_policy\" {

role = aws_iam_role.ecs_task_execution_role.name

policy_arn =
\"arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy\"

}

\# Additional Policy for Secrets Manager Access

resource \"aws_iam_role_policy\" \"ecs_task_execution_secrets_policy\" {

name = \"ecsTaskExecutionSecretsPolicy\"

role = aws_iam_role.ecs_task_execution_role.id

policy = jsonencode({

Version = \"2012-10-17\",

Statement = \[

{

Effect = \"Allow\",

Action = \[

\"secretsmanager:GetSecretValue\"

\],

Resource =
\"arn:aws:secretsmanager:us-west-2:326151034032:secret:jash_db_secret3-\*\"

}

\]

})

}

\# IAM Role for ECS Tasks (Optional, if tasks need additional
permissions)

resource \"aws_iam_role\" \"ecs_task_role\" {

name = \"ecsTaskRole\"

assume_role_policy = jsonencode({

Version = \"2012-10-17\",

Statement = \[

{

Action = \"sts:AssumeRole\",

Effect = \"Allow\",

Principal = {

Service = \"ecs-tasks.amazonaws.com\"

}

}

\]

})

tags = {

Name = \"ecsTaskRole\"

}

}

\# Policy for ECS Tasks to Access RDS (Example)

resource \"aws_iam_role_policy\" \"ecs_task_rds_policy\" {

name = \"ecsTaskRdsPolicy\"

role = aws_iam_role.ecs_task_role.id

policy = jsonencode({

Version = \"2012-10-17\",

Statement = \[

{

Effect = \"Allow\",

Action = \[

\"rds:DescribeDBInstances\",

\"rds:Connect\"

\],

Resource = \"\*\"

}

\]

})

1.  }\
    > \
    > outputs.tf\
    > \
    > output \"vpc_id\" { value = aws_vpc.jash_vpc.id }\
    > \
    > output \"public_subnet_ids\" { value =
    > \[aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id\]
    > }\
    > \
    > output \"private_subnet_ids\" { value =
    > \[aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id\]
    > }\
    > \
    > output \"rds_endpoint\" { value =
    > aws_db_instance.jash_rds.endpoint }\
    > \
    > output \"ecs_cluster_name\" { value =
    > aws_ecs_cluster.jash_ecs_cluster.name }\
    > \
    > **2. Deployment and Validation\
    > **

2.  **Initialize Terraform\
    > \
    > ** terraform init

3.  ![alt
    > text](photos/media/image3.png){width="6.5in"
    > height="3.513888888888889in"}

4.  **Validate Configuration\
    > \
    > ** terraform validate

5.  ![alt
    > text](photos/media/image1.png){width="6.5in"
    > height="0.4861111111111111in"}

6.  **Apply Configuration\
    > \
    > ** terraform apply

7.  [\
    > \
    > ](https://github.com/yashmahi88/DevOps_Training/blob/master/day32/image-3.png)[\
    > \
    > ](https://github.com/yashmahi88/DevOps_Training/blob/master/day32/image-4.png)[\
    > \
    > ](https://github.com/yashmahi88/DevOps_Training/blob/master/day32/image-5.png)[\
    > \
    > ](https://github.com/yashmahi88/DevOps_Training/blob/master/day32/image-6.png)[\
    > ](https://github.com/yashmahi88/DevOps_Training/blob/master/day32/image-7.png)

8.  **Monitor and Validate\
    > **

    -   Check the ECS services and tasks.

    -   Validate the connectivity and functionality of the web
        > application.

9.  Secrets:\
    > \
    > [![alt
    > text](photos/media/image4.png){width="6.5in"
    > height="0.9583333333333334in"}\
    > \
    > ](https://github.com/yashmahi88/DevOps_Training/blob/master/day32/image-8.png)
    > VPC with Route Table and Internet Gateway and Public&Private
    > Subnets.\
    > \
    > [![alt
    > text](photos/media/image11.png){width="6.5in"
    > height="2.4166666666666665in"}\
    > \
    > ](https://github.com/yashmahi88/DevOps_Training/blob/master/day32/image-9.png)
    > Added NAT gateway to VPC:\
    > \
    > [![alt
    > text](photos/media/image10.png){width="6.5in"
    > height="2.0in"}\
    > \
    > ](https://github.com/yashmahi88/DevOps_Training/blob/master/day32/image-19.png)
    > [![alt
    > text](photos/media/image5.png){width="6.5in"
    > height="1.9583333333333333in"}\
    > \
    > ](https://github.com/yashmahi88/DevOps_Training/blob/master/day32/image-14.png)
    > RDS:\
    > \
    > [![alt
    > text](photos/media/image14.png){width="6.5in"
    > height="3.8194444444444446in"}\
    > \
    > ](https://github.com/yashmahi88/DevOps_Training/blob/master/day32/image-10.png)
    > ECS:\
    > \
    > [![alt
    > text](photos/media/image16.png){width="6.5in"
    > height="3.8194444444444446in"}\
    > \
    > ](https://github.com/yashmahi88/DevOps_Training/blob/master/day32/image-11.png)
    > Frontend Security Group:\
    > \
    > [![alt
    > text](photos/media/image9.png){width="6.5in"
    > height="2.0in"}\
    > \
    > ](https://github.com/yashmahi88/DevOps_Training/blob/master/day32/image-17.png)
    > Backend Security Group:\
    > \
    > [![alt
    > text](photos/media/image7.png){width="6.5in"
    > height="2.0in"}\
    > \
    > ](https://github.com/yashmahi88/DevOps_Training/blob/master/day32/image-18.png)
    > Elastic IP:\
    > \
    > [![alt
    > text](photos/media/image15.png){width="6.5in"
    > height="3.0833333333333335in"}\
    > \
    > ](https://github.com/yashmahi88/DevOps_Training/blob/master/day32/image-20.png)
    > Frontend:\
    > \
    > [![alt
    > text](photos/media/image13.png){width="6.5in"
    > height="3.8194444444444446in"}\
    > \
    > ](https://github.com/yashmahi88/DevOps_Training/blob/master/day32/image-12.png)
    > [![alt
    > text](photos/media/image2.png){width="6.5in"
    > height="2.236111111111111in"}\
    > \
    > ](https://github.com/yashmahi88/DevOps_Training/blob/master/day32/image-13.png)
    > Backend:\
    > \
    > [![alt
    > text](photos/media/image12.png){width="6.5in"
    > height="2.3055555555555554in"}\
    > \
    > ](https://github.com/yashmahi88/DevOps_Training/blob/master/day32/image-16.png)
    > [![alt
    > text](photos/media/image8.png){width="6.5in"
    > height="2.3055555555555554in"}\
    > ](https://github.com/yashmahi88/DevOps_Training/blob/master/day32/image-15.png)

10. **Cleanup\
    > \
    > ** terraform destroy

![alt
text](photos/media/image6.png){width="6.5in"
height="4.194444444444445in"}
