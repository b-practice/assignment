#!/bin/bash

# Update system packages
echo "Updating system packages..."
sudo apt-get update -y || sudo yum update -y

# Install Java (required by Jenkins)
echo "Installing Java..."
# For Ubuntu
if [ -f /etc/lsb-release ]; then
  sudo apt-get install -y openjdk-11-jdk
# For Amazon Linux 2 or RHEL-based
elif [ -f /etc/os-release ]; then
  sudo yum install -y java-11-openjdk-devel
fi

# Verify Java installation
java -version
if [ $? -eq 0 ]; then
  echo "Java installed successfully."
else
  echo "Java installation failed."
  exit 1
fi

# Add Jenkins repository and key (for Ubuntu-based systems)
echo "Setting up Jenkins repository..."

if [ -f /etc/lsb-release ]; then
  wget -q -O - https://pkg.jenkins.io/keys/jenkins.io.key | sudo tee /etc/apt/trusted.gpg.d/jenkins.asc
  sudo sh -c 'echo deb http://pkg.jenkins.io/debian/ stable main > /etc/apt/sources.list.d/jenkins.list'
  sudo apt-get update -y
fi

# Add Jenkins repository and key (for Amazon Linux 2 or RHEL-based systems)
if [ -f /etc/os-release ]; then
  sudo curl -fsSL https://pkg.jenkins.io/redhat/jenkins.io.key | sudo tee /etc/yum.repos.d/jenkins.repo
  sudo yum install -y jenkins
fi

# Install Jenkins
echo "Installing Jenkins..."
if [ -f /etc/lsb-release ]; then
  sudo apt-get install -y jenkins
elif [ -f /etc/os-release ]; then
  sudo yum install -y jenkins
fi

# Start Jenkins service and enable it to run on boot
echo "Starting Jenkins service..."
if [ -f /etc/lsb-release ]; then
  sudo systemctl start jenkins
  sudo systemctl enable jenkins
elif [ -f /etc/os-release ]; then
  sudo systemctl start jenkins
  sudo systemctl enable jenkins
fi

# Open the necessary port (8080) for Jenkins (if using a firewall)
echo "Opening Jenkins port (8080) on the firewall..."
if [ -f /etc/lsb-release ]; then
  sudo ufw allow 8080
elif [ -f /etc/os-release ]; then
  sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
  sudo firewall-cmd --reload
fi

# Get Jenkins Admin Password (initial password)
echo "Retrieving Jenkins Admin password..."
cat /var/lib/jenkins/secrets/initialAdminPassword

# Print message
echo "Jenkins installation complete. Open your browser and visit http://<your-server-ip>:8080 to complete the setup."

