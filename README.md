# Infrastructure Modernisation Programme

## Overview

This project demonstrates the design, deployment, validation, security hardening, and controlled teardown of a modern AWS infrastructure environment using Terraform as Infrastructure as Code (IaC).

The project was developed as part of an infrastructure modernisation exercise for the fictional VaultBridge environment. The implementation focused on building a secure and reproducible AWS architecture while applying principles such as least privilege, network segmentation, encryption, remote state management, and Infrastructure as Code.

The infrastructure was deployed, validated, and successfully destroyed after testing to ensure that no unnecessary AWS resources were left running.

## Architecture

The infrastructure consisted of:

* Amazon VPC with a 10.0.0.0/16 CIDR range
* 2 public subnets across multiple Availability Zones
* 2 private subnets across multiple Availability Zones
* Amazon EC2 instance running Amazon Linux
* Amazon RDS PostgreSQL 15 database
* Dedicated security groups for EC2 and RDS
* Internet Gateway for public subnet connectivity
* Elastic IP for the EC2 instance
* Terraform remote state stored in Amazon S3
* DynamoDB table for Terraform state locking
* Encrypted EC2 EBS storage
* Encrypted RDS storage

### High-Level Architecture

```text
                         Internet
                            |
                            |
                    Internet Gateway
                            |
                     Public Subnets
                    /               \
                   /                 \
          EC2 Instance             EC2 Instance
          (VaultBridge)             (future)
                |
                | TCP 5432
                | EC2 Security Group
                |
          Private Subnets
           /             \
          /               \
     RDS PostgreSQL     RDS (future)
       Database
```

## Project Structure

```text
Project-3/
│
├── bootstrap/
│   ├── main.tf
│   └── .terraform.lock.hcl
│
├── infra/
│   ├── backend.tf
│   ├── ec2.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── rds.tf
│   ├── security_groups.tf
│   ├── variables.tf
│   ├── vpc.tf
│   └── .terraform.lock.hcl
│
└── .gitignore
```

### Bootstrap

The bootstrap/ configuration creates the resources required to support Terraform's remote state management:

* S3 bucket for Terraform state
* S3 versioning
* Server-side encryption
* Public access blocking
* DynamoDB state-locking table

### Infrastructure

The infra/ directory contains the main AWS infrastructure configuration.

| File                 | Purpose                                                 |
| -------------------- | ------------------------------------------------------- |
| vpc.tf             | Creates the VPC, subnets, Internet Gateway, and routing |
| ec2.tf             | Creates the EC2 instance and Elastic IP                 |
| rds.tf             | Creates the PostgreSQL RDS database and subnet group    |
| security_groups.tf | Defines EC2 and RDS network access rules                |
| variables.tf       | Defines configurable infrastructure variables           |
| providers.tf       | Configures the AWS provider                             |
| backend.tf         | Configures Terraform remote state                       |
| outputs.tf         | Exposes important infrastructure outputs                |

---

## Security Controls

Security was incorporated into the infrastructure design rather than treated as an afterthought.

### Network Segmentation

The VPC was divided into public and private subnets.

* EC2 was deployed in a public subnet.
* RDS was deployed in private subnets.
* RDS was configured as not publicly accessible.

### Security Groups

The EC2 security group allowed:

* HTTP (TCP/80) from the internet
* SSH (TCP/22) only from the administrator's IP address

The RDS security group allowed:

* PostgreSQL (TCP/5432) only from the EC2 security group

This prevented direct public access to the database.

### Encryption

Encryption was verified on both compute and database storage.

* EC2 root EBS volume: encrypted
* RDS storage: encrypted
* Terraform state S3 bucket: server-side encryption enabled

### Metadata Protection

The EC2 instance used IMDSv2 by requiring metadata tokens.

## Validation

After deployment, the infrastructure was validated from both the AWS CLI and the EC2 instance.

### RDS Connectivity

PostgreSQL connectivity was tested from the EC2 instance using:

```bash
psql -h <rds-endpoint> -U <username> -d appdb
```

The connection successfully established an SSL/TLS connection to the PostgreSQL database.

### Remote State

The Terraform state was verified in Amazon S3:

```bash
aws s3 ls s3://<bucket>/envs/dev/
```

The remote state file was successfully created and managed through the configured backend.

### Terraform State

All managed resources were reviewed using:

```bash
terraform state list
```

The deployed environment contained 17 Terraform-managed resources.

### Security Validation

Security group rules were reviewed to confirm that:

* SSH was restricted to a specific IP address.
* HTTP was explicitly exposed on the EC2 instance.
* PostgreSQL was restricted to traffic originating from the EC2 security group.
* No direct public access to RDS was permitted.

AWS CLI queries were also used to verify EC2 and RDS encryption settings.

## Infrastructure Teardown

After validation, the environment was intentionally destroyed to prevent unnecessary AWS costs and eliminate orphaned resources.

The main infrastructure was destroyed using:

```bash
terraform destroy
```

Terraform reported:

```text
Destroy complete! Resources: 17 destroyed.
```

The Terraform state was then verified:

```bash
terraform state list
```

The command returned no resources.

The VPC, RDS database, security groups, subnets, EC2 instance, Elastic IP, routing resources, and associated infrastructure were successfully removed.

The Terraform bootstrap resources were subsequently destroyed as well, including the S3 state bucket and DynamoDB locking table.

The S3 bucket initially required its versioned objects to be removed before the bucket itself could be deleted. After clearing the bucket contents, Terraform successfully completed the teardown.

## Key Learning Outcomes

This project provided hands-on experience with:

* Infrastructure as Code using Terraform
* AWS VPC architecture
* Public and private subnet design
* EC2 provisioning
* Amazon RDS PostgreSQL
* AWS security groups
* Network segmentation
* Least-privilege network access
* EBS and RDS encryption
* Terraform remote state
* S3 state storage
* DynamoDB state locking
* AWS CLI infrastructure validation
* Terraform state management
* Infrastructure teardown and resource cleanup

## Technologies Used

* Terraform
* Amazon Web Services (AWS)
* Amazon VPC
* Amazon EC2
* Amazon RDS
* Amazon S3
* Amazon DynamoDB
* AWS CLI
* PostgreSQL
* Git/GitHub


## Project Status

**Completed**

The AWS infrastructure was successfully:

1. Provisioned with Terraform
2. Validated
3. Security-audited
4. Tested for EC2-to-RDS connectivity
5. Documented
6. Destroyed successfully

The Terraform source code remains available in this repository as a reproducible infrastructure implementation.

---

## Author

**Faith Enemaku**

Cloud Security & Infrastructure | Cybersecurity

This project demonstrates practical experience with AWS infrastructure automation, cloud security controls, Terraform, network segmentation, and secure infrastructure lifecycle management.
