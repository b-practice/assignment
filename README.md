**CI/CD Pipeline for Dockerized Application on AWS EC2**

This repository demonstrates how to set up a CI/CD pipeline using Jenkins, Docker, Ansible, and AWS EC2. The pipeline automates the following:

   1. Builds a Docker image from a simple web application (Python Flask or similar).
   2. Pushes the Docker image to a Docker registry (e.g., Docker Hub).
   3. Deploys the application to an EC2 instance using Ansible.
   4. Performs post-deployment testing to ensure the application is running successfully.


**Prerequisites**

Before setting up the pipeline, ensure that the following tools are installed and configured:

   1. Jenkins (installed and running).
   2. Docker (installed on the Jenkins agent).
   3. AWS EC2 instance running and accessible with SSH (used for deployment).
   4. AWS CLI configured (for managing AWS resources, if necessary).
   5. Ansible installed on the Jenkins agent for deployment automation.


**Step-by-Step Setup Instructions**

1. Install Jenkins and Required Plugins

   Jenkins Installation:

   This below script installs Jenkins, Java (required by Jenkins), and configures it to start automatically.
   The Jenkins service will be available on port 8080.

```sh
You can use the script ** install-jenkins.sh ** to install Jenkins on an Ubuntu or Amazon Linux 2 instance:

chmod +x install-jenkins.sh
./install-jenkins.sh
```
2. Create a Jenkins Pipeline : use jenkinsfile available in the repo to create CICD pipeline
3. SetUp EC2 Instance
   You will need an EC2 instance running with public IP access. We can create EC2 instance with t2.micro type with the following :

    Security Group:
        Allow SSH (port 22) and HTTP (port 80) access.

    SSH Key:
        Ensure that your Jenkins instance can SSH into the EC2 instance using the private key.
    To Create EC2 insance, please follow the below steps

```sh
 ** Please export your secret key and access keys before the execution of the script **
 export AWS_ACCESS_KEY_ID = access key>
 export AWS_SECRET_ACCESS_KEY = <secret key>
 
 cd terraform
 # initialize Terraform
 terraform init

 # Validate / Review changes before creation
 terraform plan

 # Create Infra
 terraform apply --auto-approve
```
5.  Set Up Docker Hub Credentials in Jenkins

    1. Go to Manage Jenkins → Manage Credentials → (Global) → Add Credentials.
    2. Choose Username and Password for Docker Hub credentials and use your Docker Hub username and password.
    3. In your Jenkinsfile, make sure to reference these credentials with the ID docker-hub-credentials.

6. Run the Jenkins Pipeline

    1. Commit the Jenkinsfile and Ansible playbooks to your repository.
    2. Trigger the pipeline manually or configure it to run automatically on commits.
    3. Jenkins will automatically build the Docker image, push it to Docker Hub, deploy it on the EC2 instance using Ansible, and run post-deployment tests.


**Troubleshooting**

   1. If Docker is not installing correctly, ensure that you have the correct permissions to install software (especially on restricted environments).
   2. If Jenkins is not able to SSH into EC2, check the security group and SSH keys configuration.
   3. Ensure that the Docker Hub credentials are correctly set up in Jenkins for pushing the Docker image.