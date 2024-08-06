# Deploying a Tic-Tac-Toe Game with CI/CD

The aim of this project is to explain how to deploy a simple tic-tac-toe (or as it's funly called in Nigeria, "X & O") game using CI/CD.

### Prerequisites
- Understanding of Linux
- Access to a cloud service provider
- Understanding of Kubernetes and Docker
- Indepth knowledge of Infrastructure as Code and CI/CD

## 1. Setting Up the Development Environment
For this practice, I used DigitalOcean as my cloud provider. Then, I proceeded to create a droplet on DigitalOcean. This was very necessary as it provided a clean, isolated virtual machine where I could set up the development environment without affecting my local machine.
```
sudo apt update && sudo apt upgrade -y
```
As recommended, after spinning up a virtual machine, it's important to update the necessary packages to ensure your system has the latest security patches.

### Installing Docker 
Docker is also a very imporatant for this endeavour as it allows users to package application and its dependencies into containers, ensuring consistency across different environment. Furthermore, it easy integration to kubernetes cluster is also crucial.    
The specific commands do the following:
- Install Docker
- Start the Docker service and enable it to start on boot
- Add the root user to the Docker group (for permissions)
- Apply necessary permissions to the Docker socket

```
sudo apt install docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker
sudo usermod -aG docker root
newgrp docker
sudo chmod 777 /var/run/docker.sock
```
### Installing SonarQube
SonarQube is important for code quality as it provides continuous inspection. It helps in bug detection by identifying bugs and security vulnerabilities early in the development process. Additionally, it enforces coding standards and best practices.
```
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community
```
###  Installing Additional Tools
I created a bash script to install other tools and applications that will be needed for the successful deployment of the application. 
- Node.js: Required for running the JavaScript-based Tic-Tac-Toe game.
- .NET CLI: Useful for potential backend services or future .NET-based projects.
- Java: Required by some DevOps tools, including SonarQube.
- Terraform: Necessary for infrastructure as code (which you'll use later).
- Trivy: Important for container and filesystem security scanning.
- kubectl: Essential for managing your Kubernetes cluster.

You will find the script for the installation in teh file **install_tools.sh**

## 2. Installing and Configuring doctl
doctl is Digital Ocean's official command-line interface. 

Install doctl using Snap:
```
sudo snap install doctl
```
Login to the Digitial ocean account and generate a personal access token. 
```
# Authenticate doctl with the token
doctl auth init
# When prompted, paste the personal access token you generated

# Verify the authentication
doctl account get
```

## 3. Testing The Application  Locally
After setting up the environment, you test the application locally to be certain that it is running successfully and to get yourself familar with the required enviromental variables.  It quite neccessary as it allows you to verify that the application runs correctly in the new environment before proceeding with containerization and deployment.
```
npm install
npm start
```
## 4. Testing the Code Quality On Sonarqube 
After confirming the code is running successfully, we check and test for the code quality using sonarqube. By running SonarQube early, you can identify code quality issues, bugs, and vulnerabilities before they make it further into the pipeline or, worse, into production.

## 5. Infrastructure as Code
After setting up your development environment and testing your application locally, proceed to create a Terraform configuration to provision a Kubernetes cluster on Digital Ocean.

The `main.tf`, configuration specifies DigitalOcean as the cloud provider. It also creates a Kubernetes cluster named "tic-tac-toe-cluster." It sets up a node pool with 3 nodes. The `output.tf` returns selected output whenever the script is being deployed. 
After creating the configuration, you would run:
```
terraform init
terraform validate 
terraform plan
terraform apply --auto-approve
terraform destroy #When you want to destroy the resources
```

## 6. Containerizing the Application
With the infrastructure set up, the next step is to containerize your Tic-Tac-Toe application. Create a `Dockerfile` in your project root
```
FROM node:16

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]
```

