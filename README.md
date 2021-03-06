# aws-apache-terraform

### Table of Contents
1. [Introduction](#introduction)
1. [Terraform Layout](#terraform_layout)
    1. [General developer usage notes](#dev_notes)
        1. [Prerequisites](#prereq)
        1. [Inputs](#inputs)

# Introduction <a name="introduction"/>
This repo contains a set of Terraform modules for deployment and configuration of a Web application deployed on AWS.
The application consists of an Apache server created in a private subnet and a Bastion host used for accessing the webserver.
It will also create a user on the ec2 server, the user is created depending on the role specified. `dev` user will be created if dev role is provided
and `test` user for test role.

# Terraform Layout <a name="terraform_layout"/>

A sample of the Terraform layout in this repo is as follows:
```bash
├── deployment
│   ├── main.tf
|   ├── outputs.tf
|   ├── variables.tf
│   └── terraform.auto.tfvars
├── resources
│   ├── iam
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── network
│   ├── routes
│   ├── s3
│   └── vm
```

The main sections of the Terraform layout are:

* **_Deployment:_** This directory represents a top-level
  entry point for driving this Terraform implementation. This deployment configuration
  makes use of lower-level _resource_ modules. This directory contains the following:

* **_Resource modules:_** Each directory under _resources_ contains the
  Terraform configuration for a basic resources, such as ec2_instance,
  vpc, subnet, network_security_group, etc. The basic resources are grouped according to
  the functionality in respective directories, for example _resources/network_. 
    
## General developer usage notes <a name="dev_notes"/>

### Prerequisites <a name="prereq"/>

Please ensure to install or set the following,
* **Install Terraform** - This repo is set up using terraform version `v.1.0.7`
* **Configure AWS credentials for terraform** - Either set the following environment variables, `AWS_DEFAULT_REGION` `AWS_ACCESS_KEY_ID` `AWS_SECRET_ACCESS_KEY`
  with respective aws credentials. OR use a shared credentials file, more info [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#environment-variables)
* **AWS s3 bucket** - There should be an existing s3 bucket, this will be used to store terraform state.
* **AWS EC2 keypair** - There should be an existing ec2 keypair. This will be used when creating the bastion and webserver.  
* **SSH public key** - There should be a ssh keypair generated by user, public key will be uploaded to an encrypted s3 bucket.
And the key will also be encrypted using server side encryption(SSE:KMS)
  

## Inputs <a name="inputs"/>
The following are the mandatory fields, set the values in `terraform.auto.tfvars` and `main.tf` explained in usage below.

| Name | Description | Example | 
|------|-------------|:----:|
| role | The role of the user | "test" |
| aws\_region | AWS region for deploying all resources | "eu-west-1" |
| project | Name of the project | "test-project" |
| owner\_email | Email ID of the user | "abc@xyz.com" |
| public\_key\_path | The path to the user's ssh public key | "/home/user/.ssh/test.pub" |
| aws\_keypair | Name of an existing aws ec2 keypair | "ec2" |
| backend\_bucket | Name of an existing s3 bucket to store terraform state | "terraform-backend-19" |
| backend\_region | AWS region for the existing s3 bucket | "eu-west-1" |

### Usage <a name="usage"/>

1. Clone the git repo and navigate to deployment directory

```bash
$ https://github.com/sunnyidekar19/aws-apache-terraform.git
$ cd aws-apache-terraform/deployment
```

2. Edit `main.tf` to add the remote backend s3 config, please refer to the example below
```hcl
terraform {
  backend "s3" {
    bucket = "terraform-backend-19" # Enter name of an existing s3 bucket to store terraform state
    key    = "apache/terraform.tfstate" # can leave this as it is
    region = "eu-west-1" # AWS region for the s3 bucket
  }
}
```

3. Edit `terraform.auto.tfvars` and add values for each variable, example values are shown below
```hcl
role            = "test" # Name of user role, example: dev or test
aws_region      = "eu-west-1" # Name of aws region, example: eu-west-1
project         = "test-project" # Name of the project, example: test-project
owner_email     = "abc@xyz.com" # User email id, example: abc@xyz.com
public_key_path = "/home/user/.ssh/test.pub" # file path for user's public key
aws_keypair     = "ec2" # name of existing aws ec2 keypair
```

4. Run terraform init
```bash
$ terraform init
```

5. Run terraform plan (optional)
```bash
$ terraform plan
```

6. Run terraform apply
```bash
$ terraform apply -auto-approve
```
After the successful apply all the AWS resources will be provisioned and terraform will print the outputs, example shown below
```hcl
Outputs:

bastion_address = "34.252.222.146"
s3_pubkey_bucket = "terraform-20210926174307696100000001"
s3_user_bucket = "current-pika-testproj"
webserver_address = "10.0.20.74"
```

7. Finally, to delete all resources run terraform destroy
```bash
$ terraform destroy -auto-approve
```
