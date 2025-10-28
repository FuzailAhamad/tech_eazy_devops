# 🧩 TechEazy DevOps Automation Project

This repository provides a **fully automated Terraform + AWS setup** that deploys a complete **Spring Boot + Nginx** stack on EC2 — **without any manual steps**.  
It automatically provisions networking, builds the Java app from GitHub, configures Nginx reverse proxy, and starts everything as a `systemd` service.

---

## 🚀 Features

✅ Launches an **EC2 instance** in **Mumbai region (ap-south-1)**  
✅ Automatically creates and stores an **AWS Key Pair**  
✅ Installs:
- **Java 21 (Temurin)**
- **Maven**
- **Git**
- **Nginx**

✅ Clones and builds your app from GitHub:
https://github.com/Trainings-TechEazy/test-repo-for-devops


✅ Runs Spring Boot JAR as a **systemd service (techeazy.service)**  
✅ Configures **Nginx reverse proxy**:
http://<public_ip>/ → Spring Boot app

✅ Supports **auto-shutdown** to save AWS costs  
✅ **No manual intervention** — runs end-to-end via Terraform and cloud-init

---

## 📁 Repository Structure

| File | Description |
|------|--------------|
| `main.tf` | Main Terraform config — EC2, keypair, security group, EIP, and provisioning |
| `variables.tf` | Variables (region, instance type, stage, shutdown timing) |
| `outputs.tf` | Outputs (public IP, SSH command, instance details) |
| `user_data.sh` | Automated bootstrap script (installs, builds, deploys, and configures Nginx) |
| `.gitignore` | Ignores Terraform state files and private keys |

---

## ⚙️ Setup Instructions

### 1️⃣ Clone this repo
```
git clone https://github.com/FuzailAhamad/tech_eazy_devops_FuzailAhamad.git
cd tech_eazy_devops_FuzailAhamad
2️⃣ Initialize Terraform

terraform init -upgrade
3️⃣ Deploy Infrastructure

terraform apply -var="stage=Dev" -var="shutdown_minutes=60" -auto-approve
stage → use Dev or Prod

shutdown_minutes → set auto-shutdown time (use 0 to disable)

🌐 Access Application
After successful deployment, Terraform will print output like:

public_ip = 13.xx.xx.xx
ssh_command = ssh -i techeazy-key.pem ubuntu@13.xx.xx.xx
Visit in Browser

http://<public_ip>/
You should see the Spring Boot welcome page (Hello from Spring MVC).

🧰 Troubleshooting
If you see a 502 Bad Gateway or Nginx default page:

sudo systemctl status techeazy
sudo systemctl restart techeazy
sudo systemctl restart nginx
Check logs:

sudo journalctl -u techeazy -n 50 --no-pager
🧹 Cleanup
To destroy everything and avoid extra charges:

terraform destroy -auto-approve
📜 Notes
The Terraform setup automatically handles SSH key creation, service startup, and network configuration.

Default region: ap-south-1

App JAR name is auto-detected after Maven build (no manual rename needed).

All resources follow free-tier limits.

🧑‍💻 Author
Fuzail Ahmad
