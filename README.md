# Terraform Multienv EKS

This repository contains Infrastructure as Code (IaC) for setting up a production-ready EKS cluster in multiple environments, using Terraform.

## Modules

The codebase is organized into several modules, each serving a specific purpose:

1. **EKS:** This module deploys an Amazon Elastic Kubernetes Service (EKS) cluster in your AWS environment. It provides a managed Kubernetes platform, eliminating the need to set up, operate, and maintain your own Kubernetes control plane or worker nodes.

2. **Apps (Helm-Apps):** This module is responsible for deploying applications on the EKS cluster using Helm, a package manager for Kubernetes. It ensures that the correct configurations are applied, and manages the lifecycle of the applications.

3. **LB (Application Load Balancer):** This module provisions an AWS Application Load Balancer (ALB) for your EKS cluster. The ALB automatically distributes incoming application traffic across multiple targets, such as Amazon EC2 instances, containers, and IP addresses.

4. **TLS (Certificate for ALB):** This module generates and manages a TLS certificate for your Application Load Balancer, using AWS Certificate Manager (ACM). It provides secure, encrypted connections for your websites and applications.

5. **VPC:** This module sets up a Virtual Private Cloud (VPC) in your AWS environment. It provides an isolated, virtual network where you can launch AWS resources in a network that you define.

## Prerequisites

Before using the code in this repository, make sure you have the following:

- An AWS account
- Terraform installed on your local machine
- AWS CLI configured with appropriate permissions

## Usage

To deploy your infrastructure, follow these steps:

1. Clone this repository
2. Navigate to the project directory: `cd terraform-multienv-eks`
3. Initialize your Terraform workspace: `terraform init`
4. Create a new workspace (if required): `terraform workspace new <workspace_name>`
5. Plan your changes: `terraform plan`
6. Apply your changes: `terraform apply`

Please read the individual README files in each module directory for more specific details.

# Terraform Multienv EKS

This repository contains Infrastructure as Code (IaC) for setting up a production-ready EKS cluster in multiple environments, using Terraform.

## Modules

The codebase is organized into several modules, each serving a specific purpose:

1. **EKS:** This module deploys an Amazon Elastic Kubernetes Service (EKS) cluster in your AWS environment. It provides a managed Kubernetes platform, eliminating the need to set up, operate, and maintain your own Kubernetes control plane or worker nodes.

2. **Apps (Helm-Apps):** This module is responsible for deploying applications on the EKS cluster using Helm, a package manager for Kubernetes. It ensures that the correct configurations are applied, and manages the lifecycle of the applications.

3. **LB (Application Load Balancer):** This module provisions an AWS Application Load Balancer (ALB) for your EKS cluster. The ALB automatically distributes incoming application traffic across multiple targets, such as Amazon EC2 instances, containers, and IP addresses.

4. **TLS (Certificate for ALB):** This module generates and manages a TLS certificate for your Application Load Balancer, using AWS Certificate Manager (ACM). It provides secure, encrypted connections for your websites and applications.

5. **VPC:** This module sets up a Virtual Private Cloud (VPC) in your AWS environment. It provides an isolated, virtual network where you can launch AWS resources in a network that you define.

## Prerequisites

Before using the code in this repository, make sure you have the following:

- An AWS account
- Terraform installed on your local machine
- AWS CLI configured with appropriate permissions

### Bucket for Terraform State
```
aws s3api create-bucket --bucket terraform-state-multienv-test --create-bucket-configuration LocationConstraint=eu-west-1 --region eu-west-1
```

### DynamoDB for Terraform State
```
aws dynamodb create-table --table-name multienv-eks-terraform-state-lock --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
```

### Create Key Pair for EC2 Instances (Optional)
```
aws ec2 create-key-pair --key-name terraform_non_prod_keypair
# copy key from output to ~/.ssh/terraform_non_prod_keypair.pem
```


## Usage

To deploy your infrastructure, follow these steps:

1. Clone this repository: `git clone https://github.com/your-github-username/terraform-multienv-eks.git`
2. Navigate to the project directory: `cd terraform-multienv-eks`
3. Initialize your Terraform workspace: `terraform init`
4. Create a new workspace (if required): `terraform workspace new <workspace_name>`
5. Plan your changes: `terraform plan`
6. Apply your changes: `terraform apply`

Please read the individual README files in each module directory for more specific details.

## Contributing

Contributions are welcome! Please read the [contributing guidelines](CONTRIBUTING.md) before getting started.

## License

This project is licensed under the terms of the MIT license. 
