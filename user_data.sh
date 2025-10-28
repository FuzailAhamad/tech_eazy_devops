#!/bin/bash
set -e

# Update & install dependencies
sudo apt-get update -y
sudo apt-get install -y openjdk-21-jdk git maven nginx

# Clone the GitHub repo
cd /opt
sudo git clone https://github.com/Trainings-TechEazy/test-repo-for-devops.git
cd test-repo-for-devops

# Build Spring Boot app
sudo mvn clean package -DskipTests

# Create systemd service
sudo bash -c 'cat > /etc/systemd/system/techeazy.service <<EOF
[Unit]
Description=Spring Boot Application - TechEazy
After=network.target

[Service]
User=root
WorkingDirectory=/opt/test-repo-for-devops/target
ExecStart=/usr/bin/java -jar /opt/test-repo-for-devops/target/hellomvc-0.0.1-SNAPSHOT.jar
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF'

sudo systemctl daemon-reload
sudo systemctl enable techeazy
sudo systemctl start techeazy

# Configure Nginx reverse proxy
sudo bash -c 'cat > /etc/nginx/sites-available/techeazy <<EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF'

sudo ln -sf /etc/nginx/sites-available/techeazy /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo systemctl restart nginx
