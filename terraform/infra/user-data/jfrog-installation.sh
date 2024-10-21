#!/bin/bash

# Enable debug mode
set -x

# Log start of script execution
echo "User data script execution started" | sudo tee -a /var/log/user-data.log

# Update package list and install Docker
echo "Updating package list..." | sudo tee -a /var/log/user-data.log
sudo apt-get update
echo "Installing Docker..." | sudo tee -a /var/log/user-data.log
sudo apt-get install -y docker.io

# Start Docker and enable it to start on boot
echo "Starting Docker..." | sudo tee -a /var/log/user-data.log
sudo systemctl start docker
echo "Enabling Docker to start on boot..." | sudo tee -a /var/log/user-data.log
sudo systemctl enable docker

# Add the current user to the Docker group (if applicable)
echo "Adding current user to Docker group..." | sudo tee -a /var/log/user-data.log
sudo usermod -aG docker $USER

# Set up JFrog Artifactory environment variables
echo "Setting up JFrog Artifactory environment variables..." | sudo tee -a /var/log/user-data.log
echo "export JFROG_HOME=/opt/jfrog" | sudo tee -a /etc/profile

# Create the required directories, files, and set permissions
echo "Creating required directories and files..." | sudo tee -a /var/log/user-data.log
sudo mkdir -p /opt/jfrog/artifactory/var/etc/
sudo touch /opt/jfrog/artifactory/var/etc/system.yaml
echo "Setting permissions for /opt/jfrog/artifactory/var..." | sudo tee -a /var/log/user-data.log
sudo chown -R 1030:1030 /opt/jfrog/artifactory/var

# Generate a random 5-digit ID
echo "Generating a random 5-digit ID..." | sudo tee -a /var/log/user-data.log
NODE_ID=$(shuf -i 10000-99999 -n 1)
echo "Generated NODE_ID: $NODE_ID" | sudo tee -a /var/log/user-data.log

# Get the private IP address
echo "Getting the private IP address..." | sudo tee -a /var/log/user-data.log
PRIVATE_IP=$(hostname -I | awk '{print $1}')
echo "Private IP: $PRIVATE_IP" | sudo tee -a /var/log/user-data.log

# Update system.yaml with the private IP and generated ID
echo "Updating system.yaml with private IP and generated ID..." | sudo tee -a /var/log/user-data.log
sudo bash -c "cat <<EOF > /opt/jfrog/artifactory/var/etc/system.yaml
shared:
  node:
    id: \"$NODE_ID\"
    ip: \"$PRIVATE_IP\"
EOF"
echo "Updated /opt/jfrog/artifactory/var/etc/system.yaml" | sudo tee -a /var/log/user-data.log

# Start the Artifactory container
echo "Starting the Artifactory container..." | sudo tee -a /var/log/user-data.log
sudo docker run --name artifactory \
    -v /opt/jfrog/artifactory/var/:/var/opt/jfrog/artifactory \
    -d -p 8081:8081 -p 8082:8082 \
    releases-docker.jfrog.io/jfrog/artifactory-oss:7.77.5

# Check Artifactory logs
echo "Checking Artifactory logs..." | sudo tee -a /var/log/user-data.log
sudo docker logs -f artifactory &

# Log end of script execution
echo "User data script execution finished" | sudo tee -a /var/log/user-data.log






# version 1.0

# If you're running this on an EC2 instance, make sure the instance has the /appropriate IAM role attached with permissions to access Docker and any other /AWS services it needs. For Docker, this is generally not required unless you /need access to other AWS services from Docker. IAM policies: The role should /have policies attached that allow access to required services (e.g., S3, ECR, /etc.), if applicable.

#!/bin/bash

# # Update package list and install Docker
# sudo apt-get update
# sudo apt-get install -y docker.io

# # Start Docker and enable it to start on boot
# sudo systemctl start docker
# sudo systemctl enable docker

# # Add the current user to the Docker group (if applicable)
# sudo usermod -aG docker $USER

# # Set up JFrog Artifactory environment variables
# echo "export JFROG_HOME=/opt/jfrog" | sudo tee -a /etc/profile

# # Create the required directories, files, and set permissions
# sudo mkdir -p /opt/jfrog/artifactory/var/etc/
# sudo touch /opt/jfrog/artifactory/var/etc/system.yaml
# sudo chown -R 1030:1030 /opt/jfrog/artifactory/var

# # Generate a random 5-digit ID
# NODE_ID=$(shuf -i 10000-99999 -n 1)

# # Get the private IP address
# PRIVATE_IP=$(hostname -I | awk '{print $1}')

# # Update system.yaml with the private IP and generated ID
# sudo bash -c "cat <<EOF > /opt/jfrog/artifactory/var/etc/system.yaml
# shared:
#   node:
#     id: \"$NODE_ID\"
#     ip: \"$PRIVATE_IP\"
# EOF"

# # Start the Artifactory container
# sudo docker run --name artifactory \
#     -v /opt/jfrog/artifactory/var/:/var/opt/jfrog/artifactory \
#     -d -p 8081:8081 -p 8082:8082 \
#     releases-docker.jfrog.io/jfrog/artifactory-oss:7.77.5

# # Check Artifactory logs
# sudo docker logs -f artifactory

# # Log end of script execution
# echo "User data script execution finished" | sudo tee -a /var/log/user-data.log



# #more debugging than the immediate below. this has issues thats why its commwented out

# #!/bin/bash

# set -x
# exec > >(sudo tee -a /root/install.log) 2>&1

# trap 'echo "Error occurred on line $LINENO"; exit 1;' ERR

# echo "Starting script..."

# # Update package list and install Docker
# echo "Updating package list..."
# if ! sudo apt-get update; then
#     echo "Failed to update package list"
#     exit 1
# fi
# echo "Update successful"

# echo "Installing Docker..."
# if ! sudo apt-get install -y docker.io; then
#     echo "Failed to install Docker"
#     exit 1
# fi
# echo "Docker installation successful"

# echo "Starting Docker..."
# if ! sudo systemctl start docker; then
#     echo "Failed to start Docker"
#     exit 1
# fi
# echo "Docker started successfully"

# echo "Enabling Docker to start on boot..."
# if ! sudo systemctl enable docker; then
#     echo "Failed to enable Docker to start on boot"
#     exit 1
# fi
# echo "Docker enabled to start on boot"

# echo "Adding current user to Docker group..."
# if ! sudo usermod -aG docker $USER; then
#     echo "Failed to add user to Docker group"
#     exit 1
# fi
# echo "User added to Docker group"

# # Set up JFrog Artifactory environment variables
# echo "Setting up JFrog Artifactory environment variables..."
# if ! echo "export JFROG_HOME=/opt/jfrog" | sudo tee -a /etc/profile; then
#     echo "Failed to set up JFrog Artifactory environment variables"
#     exit 1
# fi
# echo "JFrog Artifactory environment variables set up"

# # Create the required directories, files, and set permissions
# echo "Creating required directories and setting permissions..."
# if ! sudo mkdir -p /opt/jfrog/artifactory/var/etc/; then
#     echo "Failed to create directories"
#     exit 1
# fi
# if ! sudo touch /opt/jfrog/artifactory/var/etc/system.yaml; then
#     echo "Failed to create system.yaml file"
#     exit 1
# fi
# if ! sudo chown -R 1030:1030 /opt/jfrog/artifactory/var; then
#     echo "Failed to set permissions"
#     exit 1
# fi
# echo "Directories created and permissions set"

# # Generate a random 5-digit ID
# NODE_ID=$(shuf -i 10000-99999 -n 1)

# # Get the private IP address
# PRIVATE_IP=$(hostname -I | awk '{print $1}')

# # Update system.yaml with the private IP and generated ID
# echo "Updating system.yaml with private IP and generated ID..."
# if ! sudo bash -c "cat <<EOF > /opt/jfrog/artifactory/var/etc/system.yaml
# shared:
#   node:
#     id: \"$NODE_ID\"
#     ip: \"$PRIVATE_IP\"
# EOF"; then
#     echo "Failed to update system.yaml"
#     exit 1
# fi
# echo "system.yaml updated successfully"

# # Start the Artifactory container
# echo "Starting Artifactory container..."
# if ! sudo docker run --name artifactory \
#     -v /opt/jfrog/artifactory/var/:/var/opt/jfrog/artifactory \
#     -d -p 8081:8081 -p 8082:8082 \
#     releases-docker.jfrog.io/jfrog/artifactory-oss:7.77.5; then
#     echo "Failed to start Artifactory container"
#     exit 1
# fi
# echo "Artifactory container started successfully"

# # Check Artifactory logs
# echo "Checking Artifactory logs..."
# if ! sudo docker logs -f artifactory; then
#     echo "Failed to check Artifactory logs"
#     exit 1
# fi

# # Log end of script execution
# echo "User data script execution finished" | sudo tee -a /var/log/user-data.log








#Version 2.0 this is the generic one that doesnt require automating the collection of private IP and node ID

# #!/bin/bash

# # Update package list and install Docker
# sudo apt-get update
# sudo apt-get install -y docker.io

# # Start Docker and enable it to start on boot
# sudo systemctl start docker
# sudo systemctl enable docker

# # Set up JFrog Artifactory environment variables
# export JFROG_HOME=/opt/jfrog

# # Apply the changes to the system
# echo "export JFROG_HOME=/opt/jfrog" >> /etc/profile

# # Create the required directories, files and set permissions
# mkdir -p $JFROG_HOME/artifactory/var/etc/
# touch $JFROG_HOME/artifactory/var/etc/system.yaml
# chown -R 1030:1030 $JFROG_HOME/artifactory/var

# # Allow permissions for Docker on Mac (not needed on Linux)
# # chmod -R 777 $JFROG_HOME/artifactory/var

# # Update system.yaml
# cat <<EOF > $JFROG_HOME/artifactory/var/etc/system.yaml
# shared:
#   node:
#     id: "unique-node-id"  # Replace with a unique ID of your choice for this node
#     ip: "172.168.1.100"   # Replace with the Private IP address of the host running the Artifactory server
# EOF

# # Start the Artifactory container
# docker run --name artifactory \
#     -v $JFROG_HOME/artifactory/var/:/var/opt/jfrog/artifactory \
#     -d -p 8081:8081 -p 8082:8082 \
#     releases-docker.jfrog.io/jfrog/artifactory-oss:7.77.5

# # Check Artifactory logs
# docker logs -f artifactory


# ##version 3.0

# #!/bin/bash

# # Update and install Docker
# apt-get update
# apt-get install -y docker.io

# # Start Docker and enable it to start on boot
# systemctl start docker
# systemctl enable docker

# # Add the current user to the Docker group (if applicable)
# usermod -aG docker $USER

# # Set up JFrog Artifactory environment variables
# export JFROG_HOME=/opt/jfrog

# # Apply the changes to the system
# echo "export JFROG_HOME=/opt/jfrog" >> /etc/profile

# # Create the required directories, files and set permissions
# mkdir -p $JFROG_HOME/artifactory/var/etc/
# touch $JFROG_HOME/artifactory/var/etc/system.yaml
# chown -R 1030:1030 $JFROG_HOME/artifactory/var

# # Generate a random 5-digit ID
# NODE_ID=$(shuf -i 10000-99999 -n 1)

# # Get the private IP address
# PRIVATE_IP=$(hostname -I | awk '{print $1}')

# # Update system.yaml with the private IP and generated ID
# cat <<EOF > $JFROG_HOME/artifactory/var/etc/system.yaml
# shared:
#   node:
#     id: "$NODE_ID"
#     ip: "$PRIVATE_IP"
# EOF

# # Start the Artifactory container
# docker run --name artifactory \
#     -v $JFROG_HOME/artifactory/var/:/var/opt/jfrog/artifactory \
#     -d -p 8081:8081 -p 8082:8082 \
#     releases-docker.jfrog.io/jfrog/artifactory-oss:7.77.5

# # Check Artifactory logs
# docker logs -f artifactory

 # The usermod -aG docker $USER command is intended for interactive sessions and might not be effective immediately in user-data scripts. Consider running Docker commands with sudo if this is a concern.