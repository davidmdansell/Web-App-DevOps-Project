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

The dockerfile is as follows:

```dockerfile#

# Step 1 - Use an official Python runtime as a parent image. You can use `python:3.8-slim`.
FROM --platform=linux/amd64 public.ecr.aws/docker/library/python:3.9.10-slim-buster
# Step 2 - Set the working directory in the container
WORKDIR /app
# Step 3 Copy the application files in the container
COPY . .
# Install system dependencies and ODBC driver
RUN apt-get update && apt-get install -y \
    unixodbc unixodbc-dev odbcinst odbcinst1debian2 libpq-dev gcc && \
    apt-get install -y gnupg && \
    apt-get install -y wget && \
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    wget -qO- https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql18 && \
    apt-get purge -y --auto-remove wget && \  
    apt-get clean

# Install pip and setuptools
RUN pip install --upgrade pip setuptools

# Step 4 - Install Python packages specified in requirements.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt 

# Step 5 - Expose port 5000, app is accessible from the host machine
EXPOSE 5000

AKS Terraform Project Documentation

This documentation provides an overview of the AKS (Azure Kubernetes Service) Terraform project, which is structured to provision networking resources and an AKS cluster using Infrastructure as Code (IaC) principles.

The project is organized into two main modules:

Networking Module: Responsible for provisioning necessary Azure networking services for the AKS cluster.
AKS Cluster Module: Used to provision the AKS cluster itself.

Directory Structure

networking-module/: Contains Terraform files for networking resources.
aks-cluster-module/: Contains Terraform files for the AKS cluster.
Networking Module

Input Variables
resource_group_name: Name of the Azure Resource Group where networking resources will be deployed. Default value is "myResourceGroup".
location: Azure region where networking resources will be deployed. Default value is "East US".
vnet_address_space: Address space for the Virtual Network (VNet). Default value is ["10.0.0.0/16"].
Resources Created
Azure Resource Group: Name derived from the resource_group_name variable.
Virtual Network (VNet): Named "aks-vnet".
Control Plane Subnet: Named "control-plane-subnet".
Worker Node Subnet: Named "worker-node-subnet".
Network Security Group (NSG): Named "aks-nsg".
Inbound rules:
kube-apiserver-rule: Allow traffic to the kube-apiserver (port 443) from your public IP address.
ssh-rule: Allow inbound SSH traffic (port 22) from your public IP address.
Output Variables
vnet_id: ID of the VNet.
control_plane_subnet_id: ID of the control plane subnet.
worker_node_subnet_id: ID of the worker node subnet.
networking_resource_group_name: Name of the Azure Resource Group for networking resources.
aks_nsg_id: ID of the Network Security Group.
Conclusion

This documentation outlines the structure and functionality of the AKS Terraform project. By following the defined modules and input/output variables, users can easily provision networking resources and an AKS cluster on Azure with Terraform.

For detailed usage instructions and examples, refer to the Terraform files within each module.



# TODO: Step 6 - Define Startup Command
CMD ["python", "./app.py"]


<<<<<<< HEAD
=======
## AKS Terraform Project Documentation

# This documentation provides an overview of the AKS (Azure Kubernetes Service) Terraform project, which is structured to provision networking resources and an AKS cluster using Infrastructure as Code (IaC) principles.

# The project is organized into two main modules:

- **Networking Module** : Responsible for provisioning necessary Azure networking services for the AKS cluster.
- **AKS Cluster Module** : Used to provision the AKS cluster itself.

Directory Structure

networking-module/: Contains Terraform files for networking resources.
aks-cluster-module/: Contains Terraform files for the AKS cluster.
Networking Module

# Input Variables
- resource_group_name: Name of the Azure Resource Group where networking resources will be deployed. Default value is "myResourceGroup".
- location: Azure region where networking resources will be deployed. Default value is "East US".
- vnet_address_space: Address space for the Virtual Network (VNet). Default value is ["10.0.0.0/16"].
# Resources Created
- Azure Resource Group: Name derived from the resource_group_name variable.
- Virtual Network (VNet): Named "aks-vnet".
- Control Plane Subnet: Named "control-plane-subnet".
- Worker Node Subnet: Named "worker-node-subnet".
- Network Security Group (NSG): Named "aks-nsg".
-# Inbound rules:
- kube-apiserver-rule: Allow traffic to the kube-apiserver (port 443) from your public IP address.
- ssh-rule: Allow inbound SSH traffic (port 22) from your public IP address.
# Output Variables
- vnet_id: ID of the VNet.
- control_plane_subnet_id: ID of the control plane subnet.
- worker_node_subnet_id: ID of the worker node subnet.
- networking_resource_group_name: Name of the Azure Resource Group for networking resources.
- aks_nsg_id: ID of the Network Security Group.

## Conclusion

This documentation outlines the structure and functionality of the AKS Terraform project. By following the defined modules and input/output variables, users can easily provision networking resources and an AKS cluster on Azure with Terraform.

For detailed usage instructions and examples, refer to the Terraform files within each module.
>>>>>>> refs/remotes/origin/main


## Contributors 

- [Maya Iuga], [David Ansell] (https://github.com/davidmdansell) (https://github.com/maya-a-iuga)


## License

This project is licensed under the MIT License. For more details, refer to the [LICENSE](LICENSE) file.
