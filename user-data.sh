#!/bin/bash

# Update all packages
sudo yum update -y

# Install Nginx
sudo amazon-linux-extras enable nginx1
sudo yum install -y nginx

# Enable and start Nginx
sudo systemctl enable nginx
sudo systemctl start nginx

# Create a simple HTML page
sudo bash -c 'cat <<EOF > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Nginx Web Server Started</title>
    <style>
        body { background-color: #34333d; color: white; text-align: center; padding-top: 50px; font-family: Arial, sans-serif; }
        .container { max-width: 600px; margin: auto; padding: 20px; background-color: #5d5b6b; border-radius: 10px; box-shadow: 0px 1px 32px 11px rgba(38, 37, 44, 0.49); }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome! Nginx Web Server is Running Successfully.</h1>
        <p>This is a test page. Replace this file at <code>/usr/share/nginx/html/index.html</code> to deploy your website.</p>
    </div>
</body>
</html>
EOF'

# Create health check endpoint
sudo bash -c 'cat <<EOF > /usr/share/nginx/html/health.html
healthy
EOF'

# Adjust permissions
sudo chmod -R 755 /usr/share/nginx/html

# Restart Nginx to apply changes
sudo systemctl restart nginx
