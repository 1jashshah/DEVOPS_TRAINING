**Project 01**

In this project, you will develop a simple Node.js application, deploy
it on a local Kubernetes cluster using Minikube, and configure various
Kubernetes features. The project includes Git version control practices,
creating and managing branches, and performing rebases. Additionally,
you will work with ConfigMaps, Secrets, environment variables, and set
up vertical and horizontal pod autoscaling.

## **Project 01**

## **Project Steps**

### **1. Setup Minikube and Git Repository**

**Start Minikube**:\
\
minikube start

![](photos/media/image21.png)
#### **1.2 Set Up Git Repository**

**Create a new directory for your project**:\
\
mkdir nodejs-k8s-project

cd nodejs-k8s-project

![](photos/media/image12.png)

**Initialize Git repository**:\
\
git init

![](photos/media/image15.png)

**Create a .gitignore file**:\
\
node_modules/

.env

> ![](photos/media/image2.png)

**Add and commit initial changes**:\
\
git add .

git commit -m \"Initial commit\"

![](photos/media/image1.png)

### **2. Develop a Node.js Application**

#### **2.1 Create the Node.js App**

**Initialize the Node.js project**:\
\
npm init -y

**Install necessary packages**:\
\
npm install express body-parser

![](photos/media/image4.png)

**Create app.js**:\
\
const express = require(\'express\');

const bodyParser = require(\'body-parser\');

const app = express();

const PORT = process.env.PORT \|\| 3000;

app.use(bodyParser.json());

app.get(\'/\', (req, res) =\> {

res.send(\'Hello, World!\');

});

app.listen(PORT, () =\> {

console.log(\`Server is running on port \${PORT}\`);

});

**Update package.json** to include a start script:\
\
\"scripts\": {

\"start\": \"node app.js\"

}

![](photos/media/image18.png)

#### **2.2 Commit the Node.js Application**

**Add and commit changes**:\
\
git add .

git commit -m \"Add Node.js application code\"

![](photos/media/image7.png)

### **3. Create Dockerfile and Docker Compose**

#### **3.1 Create a Dockerfile**

**Add Dockerfile**:\
\
\# Use official Node.js image

FROM node:18

\# Set the working directory

WORKDIR /usr/src/app

\# Copy package.json and package-lock.json

COPY package\*.json ./

\# Install dependencies

RUN npm install

\# Copy the rest of the application code

COPY . .

\# Expose the port on which the app runs

EXPOSE 3000

\# Command to run the application

CMD \[ \"npm\", \"start\" \]

**Create a .dockerignore file**:\
\
node_modules

.npm

![](photos/media/image5.png)

#### **3.2 Create docker-compose.yml (optional for local testing)**

**Add docker-compose.yml**:\
\
version: \'3\'

services:

app:

build: .

ports:

\- \"3000:3000\"

**Add and commit changes**:\
\
git add Dockerfile docker-compose.yml

git commit -m \"Add Dockerfile and Docker Compose configuration\"

![](photos/media/image9.png)

### **4. Build and Push Docker Image**

#### **4.1 Build Docker Image**

**Build the Docker image**:\
\
docker build -t nodejs-app:latest .

![](photos/media/image20.png)

#### **4.2 Push Docker Image to Docker Hub**

**Tag and push the image**:\
\
docker tag nodejs-app:latest your-dockerhub-username/nodejs-app:latest

docker push your-dockerhub-username/nodejs-app:latest

![](photos/media/image17.png)

**Add and commit changes**:\
\
git add .

git commit -m \"Build and push Docker image\"

![](photos/media/image22.png)

### **5. Create Kubernetes Configurations**

#### **5.1 Create Kubernetes Deployment**

**Create kubernetes/deployment.yaml**:

apiVersion: apps/v1

kind: Deployment

metadata:

name: nodejs-app-deployment

spec:

replicas: 2

selector:

matchLabels:

app: nodejs-app

template:

metadata:

labels:

app: nodejs-app

spec:

containers:

\- name: nodejs-app

image: your-dockerhub-username/nodejs-app:latest

ports:

\- containerPort: 3000

env:

\- name: PORT

valueFrom:

configMapKeyRef:

name: app-config

key: PORT

\- name: NODE_ENV

valueFrom:

secretKeyRef:

name: app-secrets

key: NODE_ENV

#### **5.2 Create ConfigMap and Secret**

**Create kubernetes/configmap.yaml**:\
\
apiVersion: v1

kind: ConfigMap

metadata:

name: app-config

data:

PORT: \"3000\"

**Create kubernetes/secret.yaml**:\
\
apiVersion: v1

kind: Secret

metadata:

name: app-secrets

type: Opaque

data:

NODE_ENV: cHJvZHVjdGlvbmFs \# Base64 encoded value for \"production\"

**Add and commit Kubernetes configurations**:\
\
git add kubernetes/

git commit -m \"Add Kubernetes deployment, configmap, and secret\"

![](photos/media/image8.png)

#### **5.3 Apply Kubernetes Configurations**

**Apply the ConfigMap and Secret**:\
\
kubectl apply -f kubernetes/configmap.yaml

kubectl apply -f kubernetes/secret.yaml

![](photos/media/image16.png)

**Apply the Deployment**:\
\
kubectl apply -f kubernetes/deployment.yaml

![](photos/media/image6.png)

### **6. Implement Autoscaling**

#### **6.1 Create Horizontal Pod Autoscaler**

**Create kubernetes/hpa.yaml**:\
\
apiVersion: autoscaling/v2beta2

kind: HorizontalPodAutoscaler

metadata:

name: nodejs-app-hpa

spec:

scaleTargetRef:

apiVersion: apps/v1

kind: Deployment

name: nodejs-app-deployment

minReplicas: 2

maxReplicas: 5

metrics:

\- type: Resource

resource:

name: cpu

target:

type: Utilization

averageUtilization: 50

![](photos/media/image13.png)

**Apply the HPA**:\
\
kubectl apply -f kubernetes/hpa.yaml

![](photos/media/image3.png)

#### **6.2 Create Vertical Pod Autoscaler**

**Create kubernetes/vpa.yaml**:\
\
apiVersion: autoscaling.k8s.io/v1beta2

kind: VerticalPodAutoscaler

metadata:

name: nodejs-app-vpa

spec:

targetRef:

apiVersion: apps/v1

kind: Deployment

name: nodejs-app-deployment

updatePolicy:

updateMode: \"Auto\"

**Apply the VPA**:\
\
kubectl apply -f kubernetes/vpa.yaml

### **7. Test the Deployment**

#### **7.1 Check the Status of Pods, Services, and HPA**

**Verify the Pods**:\
\
kubectl get pods

**Verify the Services**:\
\
kubectl get svc

**Verify the HPA**:\
\
kubectl get hpa

#### **7.2 Access the Application**

**Expose the Service**:\
\
kubectl expose deployment nodejs-app-deployment \--type=NodePort
\--name=nodejs-app-service

-   

**Get the Minikube IP and Service Port**:\
\
minikube service nodejs-app-service \--url

-   **Access the Application** in your browser using the URL obtained
    > from the previous command.

### **8. Git Version Control**

#### **8.1 Create a New Branch for New Features**

**Create and switch to a new branch**:\
\
git checkout -b feature/new-feature

**Make changes and commit**:\
\
\# Make some changes

git add .

git commit -m \"Add new feature\"

**Push the branch to the remote repository**:\
\
git push origin feature/new-feature

#### **8.2 Rebase Feature Branch on Main Branch**

**Switch to the main branch and pull the latest changes**:\
\
git checkout main

git pull origin main

**Rebase the feature branch**:\
\
git checkout feature/new-feature

git rebase main

**Resolve conflicts if any, and continue the rebase**:\
\
git add .

git rebase \--continue

**Push the rebased feature branch**:\
\
git push origin feature/new-feature \--force

### **9. Final Commit and Cleanup**

**Merge feature branch to main**:\
\
git checkout main

git merge feature/new-feature

**Push the changes to the main branch**:\
\
git push origin main

**Clean up**:\
\
git branch -d feature/new-feature

git push origin \--delete feature/new-feature

**Project 02**

Deploy a Node.js application to Kubernetes with advanced usage of
ConfigMaps and Secrets. Implement Horizontal Pod Autoscaler (HPA) with
both scale-up and scale-down policies. The project will include a
multi-environment configuration strategy, integrating a Redis cache, and
monitoring application metrics.

## **Project Setup**

### **1.1 Initialize a Git Repository**

Create a new directory for your project and initialize Git:

mkdir nodejs-advanced-k8s-project

cd nodejs-advanced-k8s-project

git init

![](photos/media/image19.png)

### 

### 

### **1.2 Create Initial Files**

Create the initial Node.js application and Docker-related files:

npm init -y

npm install express redis body-parser

![](photos/media/image10.png)

#### **app.js**

const express = require(\'express\');

const bodyParser = require(\'body-parser\');

const redis = require(\'redis\');

const app = express();

const PORT = process.env.PORT \|\| 3000;

// Connect to Redis

const redisClient = redis.createClient({

url: \`redis://\${process.env.REDIS_HOST}:\${process.env.REDIS_PORT}\`

});

redisClient.on(\'error\', (err) =\> console.error(\'Redis Client
Error\', err));

app.use(bodyParser.json());

app.get(\'/\', async (req, res) =\> {

const visits = await redisClient.get(\'visits\');

if (visits) {

await redisClient.set(\'visits\', parseInt(visits) + 1);

} else {

await redisClient.set(\'visits\', 1);

}

res.send(\`Hello, World! You are visitor number \${visits \|\| 1}\`);

});

app.listen(PORT, () =\> {

console.log(\`Server is running on port \${PORT}\`);

});

#### **Dockerfile**

FROM node:18

WORKDIR /usr/src/app

COPY package\*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD \[\"npm\", \"start\"\]

#### **.dockerignore**

node_modules

.npm

![](photos/media/image11.png)

**1. Build and push Docker image:**

docker build -t your-dockerhub-username/nodejs-advanced-app:latest .

docker push your-dockerhub-username/nodejs-advanced-app:latest

![](photos/media/image14.png)

Apply Kubernetes configurations:\
\
kubectl apply -f kubernetes/

Access the application:\
\
minikube service nodejs-advanced-app-service \--url

**2. Advanced Kubernetes Configuration**

**2.1 Deployment Configuration**

Create \`kubernetes/deployment.yaml\` to deploy the Node.js application
with Redis dependency:

\`\`\`yaml

apiVersion: apps/v1

kind: Deployment

metadata:

name: nodejs-advanced-app-deployment

spec:

replicas: 2

selector:

matchLabels:

app: nodejs-advanced-app

template:

metadata:

labels:

app: nodejs-advanced-app

spec:

containers:

\- name: nodejs-advanced-app

image: your-dockerhub-username/nodejs-advanced-app:latest

ports:

\- containerPort: 3000

env:

\- name: PORT

valueFrom:

configMapKeyRef:

name: app-config

key: PORT

\- name: REDIS_HOST

valueFrom:

configMapKeyRef:

name: redis-config

key: REDIS_HOST

\- name: REDIS_PORT

valueFrom:

configMapKeyRef:

name: redis-config

key: REDIS_PORT

\- name: NODE_ENV

valueFrom:

secretKeyRef:

name: app-secrets

key: NODE_ENV

\- name: redis

image: redis:latest

ports:

\- containerPort: 6379

### **2.2 ConfigMap for Application and Redis**

Create kubernetes/configmap.yaml to manage application and Redis
configurations:

apiVersion: v1

kind: ConfigMap

metadata:

name: app-config

data:

PORT: \"3000\"

\-\--

apiVersion: v1

kind: ConfigMap

metadata:

name: redis-config

data:

REDIS_HOST: \"redis\"

REDIS_PORT: \"6379\"

### **2.3 Secret for Sensitive Data**

Create kubernetes/secret.yaml to manage sensitive environment variables:

apiVersion: v1

kind: Secret

metadata:

name: app-secrets

type: Opaque

data:

NODE_ENV: cHJvZHVjdGlvbg== \# Base64 encoded value for \"production\"

### **2.4 Service Configuration**

Create kubernetes/service.yaml to expose the Node.js application:

apiVersion: v1

kind: Service

metadata:

name: nodejs-advanced-app-service

spec:

selector:

app: nodejs-advanced-app

ports:

\- protocol: TCP

port: 80

targetPort: 3000

type: LoadBalancer

### **2.5 Horizontal Pod Autoscaler with Scale-Up and Scale-Down Policies**

Create kubernetes/hpa.yaml to manage autoscaling:

apiVersion: autoscaling/v2

kind: HorizontalPodAutoscaler

metadata:

name: nodejs-advanced-app-hpa

spec:

scaleTargetRef:

apiVersion: apps/v1

kind: Deployment

name: nodejs-advanced-app-deployment

minReplicas: 2

maxReplicas: 5

metrics:

\- type: Resource

resource:

name: cpu

target:

type: Utilization

averageUtilization: 50

\- type: Resource

resource:

name: memory

target:

type: Utilization

averageUtilization: 70

behavior:

scaleUp:

stabilizationWindowSeconds: 30

selectPolicy: Max

policies:

\- type: Pods

value: 2

periodSeconds: 30

\- type: Resource

resource: cpu

value: 2

periodSeconds: 30

scaleDown:

stabilizationWindowSeconds: 30

selectPolicy: Min

policies:

\- type: Pods

value: 1

periodSeconds: 30

\- type: Resource

resource: memory

value: 1

periodSeconds: 30

### **2.6 Vertical Pod Autoscaler Configuration**

Create kubernetes/vpa.yaml to manage vertical scaling:

apiVersion: autoscaling.k8s.io/v1beta2

kind: VerticalPodAutoscaler

metadata:

name: nodejs-advanced-app-vpa

spec:

targetRef:

apiVersion: apps/v1

kind: Deployment

name: nodejs-advanced-app-deployment

updatePolicy:

updateMode: \"Auto\"

### **2.7 Redis Deployment**

Add a Redis deployment configuration to
kubernetes/redis-deployment.yaml:

apiVersion: apps/v1

kind: Deployment

metadata:

name: redis-deployment

spec:

replicas: 1

selector:

matchLabels:

app: redis

template:

metadata:

labels:

app: redis

spec:

containers:

\- name: redis

image: redis:latest

ports:

\- containerPort: 6379

Add Redis service configuration to kubernetes/redis-service.yaml:

apiVersion: v1

kind: Service

metadata:

name: redis-service

spec:

selector:

app: redis

ports:

\- protocol: TCP

port: 6379

targetPort: 6379

type: ClusterIP

### **2.8 Apply Kubernetes Configurations**

Apply all configurations to your Minikube cluster:

kubectl apply -f kubernetes/redis-deployment.yaml

kubectl apply -f kubernetes/redis-service.yaml

kubectl apply -f kubernetes/configmap.yaml

kubectl apply -f kubernetes/secret.yaml

kubectl apply -f kubernetes/deployment.yaml

kubectl apply -f kubernetes/service.yaml

kubectl apply -f kubernetes/hpa.yaml

kubectl apply -f kubernetes/vpa.yaml

### **2.9 Verify Deployments and Services**

Check the status of your deployments and services:

kubectl get all

Access the application via Minikube:

minikube service nodejs-advanced-app-service \--url

### **2.10 Testing Scaling**

Simulate load on the application to test the HPA:

kubectl run -i \--tty \--rm load-generator \--image=busybox
\--restart=Never \-- /bin/sh

\# Inside the pod, run the following command to generate load

while true; do wget -q -O- http://nodejs-advanced-app-service; done

### **2.11 Validate Autoscaling Behavior**

Observe the HPA behavior:

kubectl get hpa

Watch the scaling events and verify that the application scales up and
down based on the policies you configured.

## **3. Project Wrap-Up**

### **3.1 Review and Clean Up**

After completing the project, review the configurations and clean up the
Minikube environment if needed:

minikube delete
