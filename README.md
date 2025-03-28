# Leveraging High Availability with AWS Auto Scaling & Load Balancer

## 📌 Project Overview
This project deploys a **Highly Available Web Application** on AWS using **Terraform**, ensuring scalability and resilience while staying within the **AWS Free Tier**. It includes:

###  Architecture Components
- **Custom VPC** → Secure networking setup
- **EC2 Instances** → Hosting the web application (Amazon Linux and is configured as a web server using Nginx)
- **Elastic Load Balancer (ELB)** → Distributes incoming traffic
- **Auto Scaling Group** → Ensures high availability & scalability
- **Security Groups** → Manages access control

##  Key Features
✅ **High Availability** → Auto Scaling ensures uptime and reliability  
✅ **Load Balancing** → ELB efficiently distributes traffic  
✅ **Infrastructure as Code (IaC)** → Created via Terraform for consistency  

---

## 🔧 Deployment Guide
### 1️⃣ Clone the Repository
```sh
git clone https://github.com/your-repo/highly-available-webapp.git
```

### 2️⃣ Initialize Terraform
```sh
terraform init
```

### 3️⃣ Plan the Infrastructure
```sh
terraform plan
```

### 4️⃣ Apply the Configuration
```sh
terraform apply 
```

---

## Infrastructure Diagram
![Blank diagram](https://github.com/user-attachments/assets/928bcb66-27be-4346-bbd7-f9a1c84881ca)



## Additional Notes
- This setup is optimized for the **AWS Free Tier**.
- Modify `variables.tf` to customize parameters.
