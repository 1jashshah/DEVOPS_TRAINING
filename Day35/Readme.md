## **1. Launch AWS EC2 Instances**

### **a. Launch Instances**

1.  **Log into AWS Management Console**.

2.  **Navigate to EC2 Dashboard**.

3.  **Click "Launch Instance"**.

4.  **Choose Amazon Machine Image (AMI)**:

    -   Select an Ubuntu Server 20.04 LTS AMI (or another preferred
        > version).

5.  **Choose Instance Type**:

    -   Select t2.micro (eligible for free tier).

6.  **Configure Instance**:

    -   Set number of instances to 3.

    -   Ensure instances are in the same VPC and availability zone.

7.  **Add Storage**:

    -   Accept default settings or adjust as needed.

8.  **Add Tags**:

    -   Optional but recommended to tag instances.

9.  **Configure Security Group**:

    -   Create a new security group with the following rules:

        -   **SSH**: Port 22 (source: your IP or 0.0.0.0/0)

        -   **Kubernetes API**: Port 6443 (source: custom IP or
            > 0.0.0.0/0 for testing)

        -   **Prometheus**: Port 9090 (source: 0.0.0.0/0 or specific IP)

        -   **Grafana**: Port 3000 (source: 0.0.0.0/0 or specific IP)

10. ![alt
    > text](photos/media/image11.png)

11. **Review and Launch**:

    -   Review your configuration and click "Launch".

    -   Select or create a key pair to access the instances.

12. Master:

> [\
> \
> ](https://github.com/yashmahi88/DevOps_Training/blob/master/day35/image-1.png)
> Worker01:[\
> \
> ](https://github.com/yashmahi88/DevOps_Training/blob/master/day35/image-2.png)
> Worker02:[\
> ](https://github.com/yashmahi88/DevOps_Training/blob/master/day35/image-3.png)

### **b. Connect to Instances**

**Get Public IP Addresses**:

-   From the EC2 Dashboard, note the public IPs of all instances.

**SSH into Instances**:

-   Use your key pair to SSH:\
    > ssh -i \"your-key.pem\" ubuntu@\<public-ip\>

**Update Package Manager**:

sudo apt update && sudo apt upgrade -y

## **2. Set Up a Kubernetes Cluster**

### **a. Install Dependencies**

**Install Docker**:\
\
sudo apt install docker.io -y

sudo systemctl enable docker

sudo systemctl start docker

**Install Kubeadm, Kubelet, and Kubectl**:

sudo apt install -y apt-transport-https ca-certificates curl

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg \| sudo
apt-key add -

echo \"deb https://apt.kubernetes.io/ kubernetes-xenial main\" \| sudo
tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update

sudo apt install -y kubelet kubeadm kubectl

sudo apt-mark hold kubelet kubeadm kubectl

### **b. Initialize the Kubernetes Cluster (Master Node)**

**Initialize the Cluster**:\
\
sudo kubeadm init \--pod-network-cidr=10.244.0.0/16

**Set Up Kubernetes Configuration for kubectl**:

mkdir -p \$HOME/.kube

sudo cp -i /etc/kubernetes/admin.conf \$HOME/.kube/config

sudo chown \$(id -u):\$(id -g) \$HOME/.kube/config

**Install a Pod Network Addon** (Flannel):

kubectl apply -f
https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

### **c. Join Worker Nodes**

1.  **On Each Worker Node**:

    -   Execute the join command from the output of kubeadm init on the
        > master node.

Worker node 1:

![alt
text](photos/media/image6.png)

Worker node 2:

![alt
text](photos/media/image10.png)

2.  **Verify Cluster Status**:\
    > \
    > kubectl get nodes

![alt
text](photos/media/image2.png)

**Deploy a Sample Application**:\
\
kubectl create deployment nginx \--image=nginx

kubectl expose deployment nginx \--port=80 \--type=NodePort

2.  #On Master node [![alt
    > text](photos/media/image1.png)\
    > ](https://github.com/yashmahi88/DevOps_Training/blob/master/day35/image-7.png)

## **3. Deploy Prometheus on Kubernetes**

### **a. Create Namespace**

kubectl create namespace monitoring

### **b. Deploy Prometheus**

**Using Helm** (if Helm is installed):

-   **Install Helm**:\
    > \
    > curl
    > https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    > \| bash

**Add Prometheus Helm Repository**:

helm repo add prometheus-community
https://prometheus-community.github.io/helm-charts

helm repo update

**Install Prometheus**:

helm install prometheus prometheus-community/prometheus \--namespace
monitoring

-   ![alt
    > text](photos/media/image4.png){width="6.5in"
    > height="4.194444444444445in"}

**Manually Using Kubernetes Manifests**:

**Create Prometheus Configurations** (e.g., prometheus-config.yaml):\
\
apiVersion: v1

kind: Service

metadata:

name: prometheus

namespace: monitoring

spec:

ports:

\- port: 9090

targetPort: 9090

selector:

app: prometheus

type: LoadBalancer

\-\--

apiVersion: apps/v1

kind: Deployment

metadata:

name: prometheus

namespace: monitoring

spec:

replicas: 1

selector:

matchLabels:

app: prometheus

template:

metadata:

labels:

app: prometheus

spec:

containers:

\- name: prometheus

image: prom/prometheus

args:

\- \--config.file=/etc/prometheus/prometheus.yml

\- \--storage.tsdb.path=/prometheus

\- \--web.console.libraries=/usr/share/prometheus/console_libraries

\- \--web.console.templates=/usr/share/prometheus/consoles

ports:

\- name: web

containerPort: 9090

volumeMounts:

\- name: config-volume

mountPath: /etc/prometheus

\- name: storage-volume

mountPath: /prometheus

volumes:

\- name: config-volume

configMap:

name: prometheus-config

\- name: storage-volume

-   emptyDir: {}

**Apply Configurations**:

kubectl apply -f prometheus-config.yaml

### **c. Verify Prometheus**

**Check Prometheus Service**:\
\
kubectl get services -n monitoring

![alt
text](photos/media/image3.png){width="6.5in"
height="4.194444444444445in"}\
\
[![alt
text](photos/media/image7.png){width="6.5in"
height="3.5555555555555554in"}\
](https://github.com/yashmahi88/DevOps_Training/blob/master/day35/image-11.png)

**Access Prometheus**:

-   Use port-forwarding for local access:\
    > kubectl port-forward svc/prometheus -n monitoring 9090:9090

    -   Open http://localhost:9090 in your browser.

## **4. Deploy Grafana on Kubernetes**

### **a. Deploy Grafana**

**Using Helm**:

-   **Install Grafana**:\
    > \
    > helm install grafana grafana/grafana \--namespace monitoring

    -   ![alt
        > text](photos/media/image8.png)

1.  

helm install grafana grafana/grafana \\

\--namespace monitoring \\

\--create-namespace \\

\--set service.type=NodePort \\

\--set service.nodePort=30000

![alt
text](photos/media/image5.png)

### **b. Configure Grafana**

**Access Grafana**:

-   Use port-forwarding for local access:\
    > kubectl port-forward svc/grafana -n monitoring 3000:3000

    -   Open http://localhost:3000 in your browser.

1.  **Log In to Grafana**:

    -   Default username: admin

    -   Default password: admin

2.  **Add Prometheus as a Data Source**:

    -   Go to **Configuration** \> **Data Sources** \> **Add data
        > source**.

    -   Select **Prometheus** and set the URL to
        > http://prometheus.monitoring.svc.cluster.local:9090.

![alt
text](photos/media/image9.png)

## **5. Create and Configure Custom Dashboards**

### **a. Create Dashboards**

1.  **Add Panels for Metrics**:

    -   Create panels to visualize metrics like CPU usage, memory usage,
        > pod status, etc.

    -   Use Prometheus queries to populate the panels (e.g.,
        > container_cpu_usage_seconds_total).

2.  \*\*Save

Dashboards\*\*:

-   After creating dashboards, click **Save** and name your dashboard.

3.  **Share Dashboard URLs**:

    -   Use the **Share** option to get URLs or export JSON
        > configurations.

### **b. Set Up Alerts**

1.  **Create Alerts**:

    -   Go to **Alerting** \> **Alert Rules** \> **Create Alert**.

    -   Define conditions for alerts (e.g., CPU usage \> 80%).

2.  **Configure Notifications**:

    -   Set up notification channels under **Notification channels**.

## **6. Clean Up Resources**

### **a. Delete Kubernetes Resources**

**Delete Prometheus and Grafana**:\
\
helm uninstall prometheus \--namespace monitoring

helm uninstall grafana \--namespace monitoring

kubectl delete namespace monitoring

**Delete Sample Application**:

kubectl delete deployment nginx

kubectl delete service nginx

### **b. Terminate EC2 Instances**

1.  **Go to EC2 Dashboard**.

2.  **Select Instances**:

    -   Select all instances you launched for the project.

3.  **Terminate Instances**:

    -   Click **Actions** \> **Instance State** \> **Terminate**.

### **c. Clean Up Security Groups and Other Resources**

1.  **Delete Security Groups**:

    -   Go to **Security Groups** and delete the ones created for the
        > project (if not in use by other resources).

2.  **Check for Other Resources**:

    -   Ensure no leftover resources (e.g., EBS volumes, snapshots).
