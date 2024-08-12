# Kubernetes

 - environment variables
 - config file
 - secrets
 - scaling  - horizontal
            - vertical
 - 

## environment variables

 - key-value pairs that can be used to configure applications running in a containerized environment
 - allows to pass configuration settings and secrets into your containers

 - Uses :
     - Configuration Management
     - Secret Management
     - Portability

 - can be set in Kubernetes in various ways:
     - including directly in the Pod spec
     - using ConfigMaps
     - using Secrets, etc.

 - Best Practices:
     - Avoid hardcoded values
     - Secrets management
     - Consistency

 - simple example

     ```yaml
     apiVersion: v1
     kind: Pod
     metadata:
       name: myapp
     spec:
       containers:
         - name: myapp-container
           image: myapp:latest
           env:
             - name: DATABASE_URL
               value: "mysql://username:password@db.example.com:3306/mydatabase"
             - name: API_KEY
               valueFrom:
                 secretKeyRef:
                   name: myapp-secrets
                   key: api-key
     ```

     In this example:
     - `DATABASE_URL` is a direct environment variable.
     - `API_KEY` is fetched from a Kubernetes Secret called `myapp-secrets`.

---

## Secrets

 - objects used to store sensitive information, such as passwords, OAuth tokens, and SSH keys, in a secure manner.
 - provide a way to manage and distribute sensitive data needed by applications without exposing it in pod definitions or Docker images

 - Types :
     - Opaque Secrets: most common type and can store arbitrary sensitive data. encoded as base64 strings.
     - Typed Secrets: used for storing Docker registry credentials (`kubernetes.io/dockerconfigjson`), TLS certificates (`kubernetes.io/tls`), and Service Account tokens (`kubernetes.io/service-account-token`).

 - example:

     ```yaml
     apiVersion: v1
     kind: Secret
     metadata:
       name: my-secret
     type: Opaque
     data:
       username: YWRtaW4=  # base64-encoded "admin"
       password: MWYyZDFlMmU2N2Rm  # base64-encoded "1f2d1e2e67df"
     ```

---

# Scaling
 - ability to dynamically adjust the number of pods running to handle varying levels of application traffic and workload
 - types : 
     - horizontal scaling
     - vertical scaling
     - Cluster Autoscaler
     - Manual Scaling

## horizontal scaling
 - automatically scales the number of pods in a deployment, replication controller, or replica set based on observed CPU utilization
 - periodically checks the CPU utilization of pods and adjusts the number of replicas to maintain a target utilization


## vertical scaling
 - adjusts the CPU and memory requests and limits for containers in pods to optimize resource utilization.
 - uses metrics like CPU and memory usage to recommend or automatically adjust the resource requests and limits in pod



---

#### CPU Calculation

vCPU = .5 Core
GiB, MiB, KiB = 1000
GB, MB, KB = 1024





--- 
--- 
--- 
# Linux Pending Topics

ps - 









