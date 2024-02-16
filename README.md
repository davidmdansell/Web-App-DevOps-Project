# Web-App-DevOps-Project

Welcome to the Web App DevOps Project repo! This application allows you to efficiently manage and track orders for a potential business. It provides an intuitive user interface for viewing existing orders and adding new ones.

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
- [Technology Stack](#technology-stack)
- [Contributors](#contributors)
- [License](#license)

## Features

- **Order List:** View a comprehensive list of orders including details like date UUID, user ID, card number, store code, product code, product quantity, order date, and shipping date.
  
![Screenshot 2023-08-31 at 15 48 48](https://github.com/maya-a-iuga/Web-App-DevOps-Project/assets/104773240/3a3bae88-9224-4755-bf62-567beb7bf692)

- **Pagination:** Easily navigate through multiple pages of orders using the built-in pagination feature.
  
![Screenshot 2023-08-31 at 15 49 08](https://github.com/maya-a-iuga/Web-App-DevOps-Project/assets/104773240/d92a045d-b568-4695-b2b9-986874b4ed5a)

- **Add New Order:** Fill out a user-friendly form to add new orders to the system with necessary information.
  
![Screenshot 2023-08-31 at 15 49 26](https://github.com/maya-a-iuga/Web-App-DevOps-Project/assets/104773240/83236d79-6212-4fc3-afa3-3cee88354b1a)

- **Data Validation:** Ensure data accuracy and completeness with required fields, date restrictions, and card number validation.

- **Recent Changes:** Added 'Delivery Date' column to the order list and subseqently reverted back to the original version. Code changes were made to the `app.py` file and the `order_list.html` file and can be found in the `commit` history.

## Getting Started

### Prerequisites

For the application to succesfully run, you need to install the following packages:

- flask (version 2.2.2)
- pyodbc (version 4.0.39)
- SQLAlchemy (version 2.0.21)
- werkzeug (version 2.2.3)

### Usage

To run the application, you simply need to run the `app.py` script in this repository. Once the application starts you should be able to access it locally at `http://127.0.0.1:5000`. Here you will be meet with the following two pages:

1. **Order List Page:** Navigate to the "Order List" page to view all existing orders. Use the pagination controls to navigate between pages.

2. **Add New Order Page:** Click on the "Add New Order" tab to access the order form. Complete all required fields and ensure that your entries meet the specified criteria.

## Technology Stack

- **Backend:** Flask is used to build the backend of the application, handling routing, data processing, and interactions with the database.

- **Frontend:** The user interface is designed using HTML, CSS, and JavaScript to ensure a smooth and intuitive user experience.

- **Database:** The application employs an Azure SQL Database as its database system to store order-related data.

- **Version Control:** The project is managed using Git, and the codebase is hosted on GitHub.

- **Containerization:** The application is containerized using Docker, allowing for easy deployment and scaling.

# Containerization process

The **containerization** process is as follows:

### Building the Dockerfile
The Dockerfile defines the environment in which our application runs. Here are the steps we took to build it:

 - Base Image: We started with a base image that has the necessary runtime 
 ```FROM --platform=linux/amd64 public.ecr.aws/docker/library/python:3.8-slim
```
 - Dependencies: We installed the application's dependencies. by copying the `requirements.txt` file and running `pip install -r requirements.txt`.
 ```RUN apt-get update && apt-get install -y \
    unixodbc unixodbc-dev odbcinst odbcinst1debian2 libpq-dev gcc && \
    apt-get install -y gnupg && \
    apt-get install -y wget && \
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    wget -qO- https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql18 && \
    apt-get purge -y --auto-remove wget && \  
    apt-get clean
```
- Application Code: We copied our application code into the image.
- Start Command: We specified the command to run when a container is started from the image `app.py`

### Docker Commands
Here are the Docker commands we used throughout the project:

 - Build Image: `docker build -t davidmdansell/order-management-app:v1.0`. This command builds the Docker image from the Dockerfile in the current directory
 - Run Container: `docker run -p 5000:5000 davidmdansell/order-management-app:v1.0`` This command runs a container from the myapp-davidmdansell:v1.0 image and maps port 5000 in the container to port 5000 on the host.
 - Push to Docker Hub: `docker push davidmdansell/davidmdansell/order-management-app:v1.0` This command pushes the davidmdansell/order-management-app:v1.0 image to Docker Hub.
 - Image Information
Name: davidmdansell/order-management-app
Tags: v1.0
Instructions for Use: To run a container from this image, use `docker run -p 5000:5000 davidmdansell/order-management-app:v1.0`

### Cleanup
To maintain a tidy development environment, we regularly clean up unnecessary Docker resources:

 - Remove Unused Containers: `docker rm`
 - Remove Unused Images: `docker rmi`
 - Remove Unused Volumes: `docker volume rm `


# Networking Services Definition using IaC with Terraform

next we define and provision networking services using Infrastructure as Code (IaC) with Terraform. 

## Steps to Define Networking Resources

### 1. Setup

install Terraform using Homebrew.

```brew install terraform
```

### 2. Configuration

#### 2.1. Provider Configuration

provision the Azure provider to define the infrastructure in Azure.

```terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.0.0"
    }
  }
}
```

#### 2.2. Networking Resources Definition

define the networking resources required for the app

**Virtual Network**: A virtual network (VNet)enables Azure resources to communicate with each other securely. Defined as below:

```resource "azurerm_virtual_network" "aks-vnet" {
  name                = "aks-vnet"
  location            = azurerm_resource_group.networking.location
  resource_group_name = azurerm_resource_group.networking.name
  address_space       = var.vnet_address_space
}
```
**Subnets**: Subnets allow you to segment the virtual network into multiple smaller networks for better organization and security. Define subnets as below.

```resource "azurerm_subnet" "control-plane-subnet" {
  name                 = "control-plane-subnet"
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.aks-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "worker-node-subnet" {
  name                 = "worker-node-subnet"
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.aks-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
```

**Security Groups**: Security groups act as a virtual firewall for controlling inbound and outbound traffic to network interfaces. Define security groups as below.

```resource "azurerm_network_security_group" "aks-nsg" {
  name                = "aks-nsg"
  location            = azurerm_resource_group.networking.location
  resource_group_name = azurerm_resource_group.networking.name
}
We then set up the following rules to allow inbound traffic to the kube-apiserver (TCP/443) and SSH (TCP/22) from a specific public IP address.

```

```# Allow inbound traffic to kube-apiserver (TCP/443) from your public IP address
resource "azurerm_network_security_rule" "kube-apiserver-rule" {
  name                        = "kube-apiserver-rule"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "148.252.158.53"  
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.networking.name
  network_security_group_name = azurerm_network_security_group.aks-nsg.name
}

# Allow inbound traffic for SSH (TCP/22) - Optional
resource "azurerm_network_security_rule" "ssh-rule" {
  name                        = "ssh-rule"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "148.252.158.53" 
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.networking.name
  network_security_group_name = azurerm_network_security_group.aks-nsg.name
}
```
# 3. Input and Output Variables

## 3.1. Input Variables

We define the folllowing input variables for our Terraform configuration.

```variable "resource_group_name" {
    description = "the name of the resource group in which the AKS cluster will be created"
    type        = string
    default     = "networking-rg"
  
}

variable "location" {
    description = "location of the AKS cluster"
    type        = string
    default     = "UK South"
}

variable "vnet_address_space" {
    description = "address space for the Virtual Network (VNet)"
    type        = list (string)
    default     = ["10.0.0.0/16"]
}
```

## 3.2. Output Variables

We define the following output variables to retrieve information from the created networking resources.

```output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.example.id
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = azurerm_subnet.example.id
}
```
# AKS Cluster Provisioning with Terraform

## We then use Terraform to provision an Azure Kubernetes Service (AKS) cluster.

### Prerequisites
- Azure CLI
- Terraform v0.14 or later

### Input Variables

```variable "aks_cluster_name" {
    description = "the name of the AKS cluster created"
    type        = string
    default     = "terraform-aks-cluster"
    
}

variable "cluster_location" {
    description = "location of the AKS cluster"
    type        = string
    default     = "UK South"
}

variable "dns_prefix" {
    description = "the DNS prefix creates the unique DNS identifier for the cluster"
    type        = string
    default     = "myaks-project"

}

variable "kubernetes_version" {
    description = "version of Kubernetes to be used for the cluster"
    type        = string
    default     = "1.26.6"
}

variable "service_principal_client_id" {
    description = "Client ID of the service principal used for authenticating and managing the AKS cluster"
    type        = string

}

variable "service_principal_client_secret" {
    description = "Client Secret associated with the service principal used for AKS cluster authentication"
    type        = string
    
}
```
# Input variables from the networking module

```variable "vnet_id" {
  description = "ID of the Virtual Network (VNet)."
  type       = string
  
}

variable "control_plane_subnet_id" {
  description = "ID of the control plane subnet."
  type       = string

}

variable "worker_node_subnet_id" {
  description = "ID of the worker node subnet."
  type        = string

}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group for networking resources."
  type        = string

}

variable "aks_nsg_id" {
  description = "ID of the Network Security Group (NSG) for AKS."
  type        = string
}
```

### Output Variables

```# Output the kube_config
output "kube_config" {
  description = "Kube config for connecting to the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
}

# Output aks_cluster_name
output "aks_cluster_name" {
  description = "The name of the AKS cluster created"
  value       = azurerm_kubernetes_cluster.aks_cluster.name
}

# Output aks_cluster_id
output "aks_cluster_id" {
  description = "The ID of the AKS cluster created"
  value       = azurerm_kubernetes_cluster.aks_cluster.id
```
# Main Configuration File
The main configuration file (main.tf) is where we define our provider and call our modules.

## Provider Configuration

```terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  client_id       = var.client_id
  client_secret   = var.client_secret
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}
```
This block sets up the Azure provider. 

## Networking Module

The networking module sets up a virtual network in Azure. Here's how we call it:

```module "networking" {
  source  = "./modules/networking"
  version = "1.0.0"

  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
}
```

This block calls the networking module and passes in some variables that the module needs.

## Cluster Module
The cluster module sets up an AKS cluster. Here's how we call it:

```module "cluster" {
  source  = "./modules/cluster"
  version = "1.0.0"

  resource_group_name = var.resource_group_name
  location            = var.location
  cluster_name        = var.cluster_name
  node_count          = var.node_count
}
```
This block calls the cluster module, and passes in some variables that the module needs.

## Input Variables
Here are the input variables used in the main configuration file:
```variable "client_id" {
  description = "Access key for the provider"
  type        = string
  sensitive   = true
}
```variable "client_id" {
  description = "Access key for the provider"
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Secret key for the provider"
    type        = string
    sensitive   = true
}

variable "subscription_id" {
  description = "The subscription ID for the Azure account"
  type        = string
}

variable "tenant_id" {
  description = "The tenant ID for the Azure account"
  type        = string
}
```
## Steps to Provision the AKS Cluster

### 1. Install Azure CLI and Terraform

Install the Azure CLI and Terraform if you haven't already and log in to your Azure account with `az login`.

### 2. Clone the Repository

Clone this repository to your local machine.

### 3. Initialize Terraform

Navigate to the directory containing the Terraform files and initialize Terraform with `terraform init`. This will download the necessary provider plugins.

### 4. Create a Plan

Run `terraform plan` to create an execution plan and see what resources Terraform will create or modify.

### 5. Apply the Configuration

Run `terraform apply` to create the defined resources. Terraform will prompt you to confirm that you want to create the resources.

### 6. Access the AKS Cluster

Once the resources are created, you can access your AKS cluster with `az aks get-credentials --resource-group networking-rg --name terraform-aks-cluster.`

Conclusion

By following the steps outlined above, we effectively define networking services using Infrastructure as Code with Terraform. This approach enables us to automate the provisioning and management of networking resources, leading to improved scalability, consistency, and reliability of our infrastructure.

# Kubernetes Deployment
This project uses Kubernetes to deploy the application on an Azure Kubernetes Service (AKS) cluster.

## Deployment and Service Manifests
The Deployment and Service manifests define how our application is deployed on the Kubernetes cluster and how it is exposed to the network.

### Deployment Manifest
The Deployment manifest (application-manifest.yaml) defines a Deployment that manages a Pod. The Pod runs a container based on our application's Docker image. The Deployment ensures that a specified number of replicas of the Pod are running at all times.

Key concepts and configuration settings in the Deployment manifest include:

 - replicas: The number of Pod replicas to run.
 - selector: A label selector that determines what Pods the Deployment manages.
 - template: The template for creating new Pods. This includes the Docker image to use, the desired ports to expose, and any environment variables the application needs.
 - Service Manifest
The Service manifest (service.yaml) defines a Service that exposes our application to the network. The Service routes traffic to the Pods managed by our Deployment.

Key concepts and configuration settings in the Service manifest include:

 - selector: A label selector that determines what Pods the Service routes traffic to.
 - ports: The ports that the Service exposes, both internally within the cluster and externally to the network.
 - type: The type of Service. This can be ClusterIP (default), NodePort, LoadBalancer, or ExternalName.
 - Deployment Strategy
We've chosen the RollingUpdate deployment strategy. This strategy gradually replaces old Pods with new ones. It ensures the application remains available during the update and allows us to roll back if something goes wrong. This strategy aligns with our application's requirements because it allows us to update our application with zero downtime.

### Testing and Validation
After deploying our application, we test and validate it to ensure it functions correctly within the AKS cluster.

We conduct the following tests:

> Connectivity Test: We verify that we can connect to our application through the Service.
Functionality Test: We verify that our application responds correctly to various inputs.
Performance Test: We verify that our application performs well under load.
These tests ensure the functionality and reliability of our application within the AKS cluster.

#### Distribution
To distribute the application to other internal users within our organization, we can expose the Service externally by setting its type to LoadBalancer. This creates a load balancer in Azure that routes traffic to our Service.

To share the application with external users, we can provide them with the public IP address of the load balancer. However, we need to ensure that our application is secure before doing so. This would include implementing authentication and authorization, encrypting traffic with HTTPS, and regularly updating our application to patch any security vulnerabilities.

# CI/CD Pipeline in Azure DevOps
This project uses Azure DevOps for continuous integration and continuous deployment (CI/CD).

## CI/CD Pipeline Configuration
The CI/CD pipeline is configured as follows:

### Source Repository
The source repository is hosted on GitHub. It contains our application code, Dockerfile, and Kubernetes manifests.

### Build Pipeline
The build pipeline is triggered whenever a change is pushed to the source repository. It performs the following steps:

 - Checkout: It checks out the code from the source repository.
 - Build Docker Image: It builds a Docker image from our Dockerfile.
 - Push Docker Image: It pushes the Docker image to Docker Hub.
 - The build pipeline is defined in the azure-pipelines 2.yml file in the root of the source repository.

```trigger:
- main

pool:
  vmImage: 'ubuntu-latest'

steps:
- task: Docker@2
  inputs:
    containerRegistry: 'flask-app' # Your Docker Hub connection service name
    repository: 'davidmdansell/order-management-app' # Replace with your Docker Hub username and image name
    command: 'buildAndPush'
    Dockerfile: '**/Dockerfile' # Path to your Dockerfile
    tags: 'v1.0'
- task: KubernetesManifest@1
  inputs:
    action: 'deploy'
    connectionType: 'azureResourceManager'
    azureSubscriptionConnection: 'Dario Stefano DevOps(4)(5668e4c9-8365-4a1a-80b3-233adb861c80)'
    azureResourceGroup: 'networking-rg'
    kubernetesCluster: 'terraform-aks-cluster'
    manifests: 'application-manifest.yaml'
```

### Validation
After deploying our application, we validate it to ensure it functions correctly within the AKS cluster.

#### testing

 - Connectivity Test: We verify that we can connect to our application through the Service.
 - Functionality Test: We verify that our application responds correctly to various inputs.

# Monitoring and Alarms in AKS
This project uses **Azure Monitor** and **Azure Log Analytics** for monitoring and logging.

### Enabling Container Insights for AKS Cluster

#### Introduction
Container Insights is used for collecting real-time performance and diagnostic data from your AKS clusters. By enabling Container Insights, we can monitor application performance and troubleshoot issues. First we need to enable Container Insights, including enabling managed identity, setting necessary permissions for the Service Principal, and finally enabling Container Insights.

#### Prerequisites
Azure CLI installed.
Azure Kubernetes Service (AKS) cluster already provisioned.
Permissions to manage resources in Azure.

#### Steps
##### Enable Managed Identity on the AKS Cluster:
First, ensure you have the necessary permissions to enable managed identity on the AKS cluster.
Use the following Azure CLI command to enable managed identity on the AKS cluster: 
`az aks update -n <aks-cluster-name> -g <resource-group> --enable-managed-identity`
 - Set Necessary Permissions for the Service Principal:
After enabling managed identity, we need to assign the necessary role to the AKS cluster's managed identity using azure portal or Azure CLI.
 - Monitoring Metrics Publisher: Grants permission to publish monitoring metrics to Azure Monitor. This is important for applications and services that need to push metrics to Azure Monitor.
 - Monitoring Contributor: Grants broad permissions for monitoring and managing monitoring resources in Azure, including permissions to read and write monitoring settings, access monitoring data and manage monitoring resources
 - Log Analytics Contributor: Grants permissions to read and write access to Log Analytics workspaces. Includes permissions to query and analyze log data stored in those workspaces.
##### Enable Container Insights on the AKS Cluster:
With managed identity and necessary permissions set up, we can now enable Container Insight

## Metrics Explorer Charts
We use several Metrics Explorer charts to monitor our AKS cluster:

 - Average Node CPU Usage: This chart allows you to track the CPU usage of your AKS cluster's nodes. Monitoring CPU usage helps ensure efficient resource allocation and detect potential performance issues.
 - Average Pod Count: This chart displays the average number of pods running in your AKS cluster. It's a key metric for evaluating the cluster's capacity and workload distribution.
 - Used Disk Percentage: Monitoring disk usage is critical to prevent storage-related issues. This chart helps you track how much disk space is being utilized.
 - Bytes Read and Written per Second: Monitoring data I/O is crucial for identifying potential performance bottlenecks. This chart provides insights into data transfer rates.
![cpu and memory usage](https://github.com/davidmdansell/Web-App-DevOps-Project/blob/main/screenshots/containerinsights1)
![useddisk% and bytes read and written per second](https://github.com/davidmdansell/Web-App-DevOps-Project/blob/main/screenshots/containerinsight2.jpeg)

## Log Analytics
We analyze several types of logs through Log Analytics:

 - Average Node CPU Usage Percentage per Minute: This configuration captures data on node-level usage at a granular level, with logs recorded per minute
 ![cpuusageperminute](https://github.com/davidmdansell/Web-App-DevOps-Project/blob/main/screenshots/Average%20Node%20CPU%20Usage%20Percentage%20per%20Minute.jpeg)
 - Average Node Memory Usage Percentage per Minute: Similar to CPU usage, tracking memory usage at node level allows you to detect memory-related performance concerns and efficiently allocate resources
 ![memoryusageperminute](https://github.com/davidmdansell/Web-App-DevOps-Project/blob/main/screenshots/Average%20Node%20Memory%20Usage%20Percentage%20per%20Minute.jpeg)
 - Pods Counts with Phase: This log configuration provides information on the count of pods with different phases, such as Pending, Running, or Terminating. It offers insights into pod lifecycle management and helps ensure the cluster's workload is appropriately distributed.
 ![podcountswithphase](https://github.com/davidmdansell/Web-App-DevOps-Project/blob/main/screenshots/Pods%20Counts%20with%20Phase.jpeg)
 - Find Warning Value in Container Logs: By configuring Log Analytics to search for warning values in container logs, you proactively detect issues or errors within your containers, allowing for prompt troubleshooting and issues resolution
 - Monitoring Kubernetes Events: Monitoring Kubernetes events, such as pod scheduling, scaling activities, and errors, is essential for tracking the overall health and stability of the cluster

## Alarms
We have provisioned several alarms for our monitoring system: each alarm is triggered when a specific metric exceeds a certain threshold for a defined period of time and sends an email notification to the DevOps team.

 - Disk Used Alarm: This alarm is triggered when the disk usage exceeds 90% for 5 minutes. This may indicate that we need to allocate additional storage or clean up unnecessary files to prevent storage-related issues.
 - CPU Usage Alarm: This alarm is triggered when the CPU usage exceeds 80% for 5 minutes. This may indicate that we need to scale up our nodes or pods or face possible performance degredation or service outage.
 - Memory Usage Alarm: This alarm is triggered when the memory usage exceeds 80% for 5 minutes. This may indicate that we need to scale up our nodes or pods.

## Alarm Response Procedures
When an alarm is triggered, we follow these general steps:

 - Acknowledge the Alarm: Acknowledge the alarm to prevent it from notifying other team members.
 - Investigate the Issue: Check the relevant Metrics Explorer charts and Log Analytics logs to diagnose the issue.
 - Take Action: Depending on the issue, take the appropriate action. This may involve scaling up the nodes or pods, allocating additional capacity, or troubleshooting potential issues.
 - Verify the Solution: After taking action, monitor the Metrics Explorer charts and Log Analytics logs to ensure the issue has been resolved.
 - Document the Incident: Document the incident, including the root cause, actions taken, and any follow-up steps required.

# Secrets Management and AKS Integration with Azure Key Vault
This project uses Azure Key Vault for secrets management and integrates it with our AKS cluster.

## Azure Key Vault Setup
We set up an Azure Key Vault to securely store our application's secrets. We assigned the following permissions:

 - Key Permissions: We granted the get, list, update, create, import, delete, recover, backup, and restore permissions to our application's service principal.
 - Secret Permissions: We granted the get, list, set, delete, recover, backup, and restore permissions to our application's service principal.

## Secrets in Key Vault
We store the following secrets in Key Vault:
 - server name
 - server username
 - server password 
 - database name
AKS Integration with Key Vault
We integrated our AKS cluster with Key Vault using Azure's Managed Identity feature. Here are the steps we took:

## Create a Managed Identity
We created a managed identity that our AKS cluster uses to authenticate with Azure services.

## Assign Permissions to the Managed Identity
We assigned the get and list secret permissions to the managed identity for our Key Vault. This allows the AKS cluster to retrieve secrets from the Key Vault.

## Configure AKS to Use the Managed Identity
We configured our AKS cluster to use the managed identity in the AKS cluster configuration.

## Application Code Modifications
We modified our application code to use the managed identity to retrieve the database connection string from Key Vault:

```# secrets management using azure key vault
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient

credential = DefaultAzureCredential()
vault_url = "https://myappdavidmdansell.vault.azure.net/"

# Create a SecretClient using the managed identity credentials
client = SecretClient(vault_url=vault_url, credential=credential)

# List of secret names you want to retrieve
secret_names = ["myappdavidmdansell-dbname", "myappdavidmdansell-servername", "myappdavidmdansell-serverusrnm", "myappdavidmdansell-svrpass"]

secrets = {}
for secret_name in secret_names:
    retrieved_secret = client.get_secret(secret_name)
    secrets[secret_name] = retrieved_secret.value
database = secrets["myappdavidmdansell-dbname"]
server = secrets["myappdavidmdansell-servername"]
username = secrets["myappdavidmdansell-serverusrnm"]
password = secrets["myappdavidmdansell-svrpass"]
```
This code uses the DefaultAzureCredential class, which automatically uses the managed identity when running on AKS.

## Contributors
- [Maya Iuga], [David Ansell] (https://github.com/davidmdansell) (https://github.com/maya-a-iuga)


## License

This project is licensed under the MIT License. For more details, refer to the [LICENSE](LICENSE) file.
