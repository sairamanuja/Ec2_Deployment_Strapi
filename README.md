# 🏗️ Strapi on AWS EC2 - Complete Architecture Documentation

## 📋 Deployment Overview

**Status:** ✅ **SUCCESSFULLY DEPLOYED**
- **Application URL:** http://13.232.203.70:1337
- **Admin Panel:** http://13.232.203.70:1337/admin  
- **Instance IP:** 13.232.203.70
- **Region:** ap-south-1 (Mumbai)

---

## 🏛️ Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                        AWS ap-south-1                      │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │               VPC (10.0.0.0/16)                     │   │
│  │                                                     │   │
│  │  ┌─────────────────┐    ┌─────────────────────────┐ │   │
│  │  │ Internet Gateway│    │   Public Subnet         │ │   │
│  │  │   (IGW)         │◄───│   (10.0.1.0/24)        │ │   │
│  │  └─────────────────┘    │   ap-south-1a           │ │   │
│  │                         │                         │ │   │
│  │                         │  ┌─────────────────┐    │ │   │
│  │                         │  │   EC2 Instance  │    │ │   │
│  │                         │  │   Ubuntu 20.04  │    │ │   │
│  │                         │  │   t3.small      │    │ │   │
│  │                         │  │                 │    │ │   │
│  │                         │  │  ┌─────────────┐│    │ │   │
│  │                         │  │  │   Docker    ││    │ │   │
│  │                         │  │  │             ││    │ │   │
│  │                         │  │  │ ┌─────────┐ ││    │ │   │
│  │                         │  │  │ │ Strapi  │ ││    │ │   │
│  │                         │  │  │ │Container│ ││    │ │   │
│  │                         │  │  │ │:1337    │ ││    │ │   │
│  │                         │  │  │ │         │ ││    │ │   │
│  │                         │  │  │ │SQLite DB│ ││    │ │   │
│  │                         │  │  │ └─────────┘ ││    │ │   │
│  │                         │  │  └─────────────┘│    │ │   │
│  │                         │  └─────────────────┘    │ │   │
│  │                         └─────────────────────────┘ │   │
│  │                                                     │   │
│  │  ┌─────────────────────────────────────────────┐   │   │
│  │  │           Security Group                    │   │   │
│  │  │  • SSH (22) - 0.0.0.0/0                   │   │   │
│  │  │  • HTTP (1337) - 0.0.0.0/0                │   │   │
│  │  │  • All Outbound - 0.0.0.0/0               │   │   │
│  │  └─────────────────────────────────────────────┘   │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
                        Internet Users
                     (Port 1337 Access)
```

---

## 🧩 Component Breakdown

### 🌐 **Network Infrastructure**
```yaml
VPC:
  Name: strapi-vpc
  CIDR: 10.0.0.0/16
  DNS Support: Enabled
  DNS Hostnames: Enabled

Subnet:
  Name: strapi-subnet
  CIDR: 10.0.1.0/24
  Type: Public
  AZ: ap-south-1a
  Auto-assign Public IP: Enabled

Internet Gateway:
  Name: strapi-igw
  Purpose: Internet access for public subnet

Route Table:
  Name: strapi-route-table
  Routes:
    - 0.0.0.0/0 → Internet Gateway
```

### 🛡️ **Security**
```yaml
Security Group: strapi-sg
Inbound Rules:
  - SSH: Port 22, Source: 0.0.0.0/0
  - Strapi: Port 1337, Source: 0.0.0.0/0
  
Outbound Rules:
  - All Traffic: All Ports, Destination: 0.0.0.0/0

SSH Key: sai (existing AWS key pair)
```

### 💻 **Compute Resources**
```yaml
EC2 Instance:
  Name: strapi-ec2
  AMI: Ubuntu 20.04 LTS (ami-06cc5ebfb8571a147)
  Instance Type: t3.small
  vCPUs: 2
  Memory: 2 GiB
  Storage: Default EBS (8 GiB)
  
Network:
  VPC: strapi-vpc
  Subnet: strapi-subnet
  Public IP: 13.232.203.70
  Security Group: strapi-sg
```

### 🐳 **Containerization**
```yaml
Docker Setup:
  Engine: Docker CE (latest)
  Registry: Docker Hub
  
Container:
  Image: sairamanuja789/strapi-app:latest
  Name: strapi-app
  Port Mapping: 1337:1337
  Restart Policy: unless-stopped
  
Environment Variables:
  - NODE_ENV: production
  - HOST: 0.0.0.0
  - PORT: 1337
  - DATABASE_CLIENT: sqlite
  - DATABASE_FILENAME: .tmp/data.db
  - APP_KEYS: key1,key2,key3,key4
  - JWT_SECRET: myJwtSecret
  - ADMIN_JWT_SECRET: myAdminSecret
  - API_TOKEN_SALT: myApiTokenSalt
  - TRANSFER_TOKEN_SALT: myTransferTokenSalt
```

### 📊 **Application Stack**
```yaml
Application: Strapi CMS
Version: 5.31.3
Runtime: Node.js 20 Alpine
Database: SQLite (embedded)
Port: 1337

Dependencies:
  - @strapi/strapi: 5.31.3
  - better-sqlite3: 12.4.1
  - react: 18.x
  - Additional Strapi plugins
```

---

## 📁 **File Structure**
```
my-strapi/
├── 🐳 Docker Configuration
│   ├── Dockerfile                    # Multi-stage container build
│   ├── .dockerignore                 # Build exclusions
│   └── docker-compose.yml            # Local development
│
├── ☁️ Infrastructure as Code
│   ├── terraform/
│   │   ├── main.tf                   # Core resources
│   │   ├── provider.tf               # AWS provider config
│   │   ├── security.tf               # VPC, Security Groups
│   │   ├── variables.tf              # Input variables
│   │   ├── outputs.tf                # Output values
│   │   └── terraform.tfvars          # Variable values
│   └── userdata_dockerhub.tpl        # EC2 initialization script
│
├── 🚀 Deployment Scripts
│   └── scripts/
│       ├── build-and-push.sh         # Docker image build/push
│       └── deploy.sh                 # Full deployment automation
│
├── ⚙️ Strapi Application
│   ├── src/                          # Application source code
│   ├── config/                       # Strapi configuration
│   ├── database/                     # Database files
│   ├── public/                       # Static assets
│   ├── package.json                  # Node.js dependencies
│   └── .env                          # Environment variables
│
└── 📚 Documentation
    ├── Task3.md                      # Docker guide
    ├── Task4.md                      # Extended Docker concepts
    └── Task5.md                      # Deployment guide
```

---

## 🔄 **Deployment Flow**

### **1. Local Development**
```bash
# Build and test locally
docker-compose up -d
# Access: http://localhost:1337
```

### **2. Image Preparation**
```bash
# Build and push to registry
./scripts/build-and-push.sh
# Result: sairamanuja789/strapi-app:latest
```

### **3. Infrastructure Deployment**
```bash
cd terraform/
terraform init
terraform plan
terraform apply
# Result: Complete AWS infrastructure
```

### **4. Application Deployment**
```bash
# Automated via user-data script:
# 1. Install Docker
# 2. Pull image from Docker Hub
# 3. Run Strapi container
# 4. Configure environment
```

---

## 🌍 **Access Points**

### **Public Endpoints**
- **Main Application:** http://13.232.203.70:1337
- **Admin Dashboard:** http://13.232.203.70:1337/admin
- **API Endpoint:** http://13.232.203.70:1337/api

### **SSH Access**
```bash
ssh -i ~/.ssh/sai.pem ubuntu@13.232.203.70
```

### **Container Management**
```bash
# View logs
docker logs strapi-app

# Restart container
docker restart strapi-app

# Container status
docker ps
```

---

## 🔧 **Configuration Management**

### **Terraform Variables**
```hcl
# terraform/terraform.tfvars
key_name = "sai"
dockerhub_image = "sairamanuja789/strapi-app:latest"
aws_region = "ap-south-1"
instance_type = "t3.small"
```

### **Strapi Environment**
```bash
# Container environment variables
NODE_ENV=production
DATABASE_CLIENT=sqlite
HOST=0.0.0.0
PORT=1337
```

---

## 📈 **Monitoring & Maintenance**

### **Health Checks**
- **Application:** http://13.232.203.70:1337 (HTTP 200)
- **Container Status:** `docker ps`
- **System Logs:** `/var/log/user-data.log`

### **Backup Strategy**
- **Database:** SQLite file in container volume
- **Uploads:** `/app/public/uploads` directory
- **Configuration:** Environment variables

### **Scaling Considerations**
- **Vertical:** Increase instance type (t3.medium, t3.large)
- **Horizontal:** Load balancer + multiple instances
- **Database:** Migrate to RDS for production

---

## 🎯 **Success Metrics**

✅ **Infrastructure:** 7 AWS resources deployed successfully
✅ **Application:** Strapi running on port 1337
✅ **Security:** Proper VPC isolation and security groups
✅ **Accessibility:** Public internet access configured
✅ **Automation:** Fully automated deployment pipeline
✅ **Documentation:** Complete architecture documentation

---

## 🔄 **Next Steps & Improvements**

### **Production Readiness**
1. **SSL/TLS:** Add Load Balancer with SSL certificate
2. **Database:** Migrate to RDS PostgreSQL
3. **Monitoring:** CloudWatch logs and metrics
4. **Backup:** Automated backup strategy
5. **Auto-scaling:** Auto Scaling Groups
6. **CI/CD:** GitHub Actions pipeline

### **Security Enhancements**
1. **Restrict SSH:** Limit to specific IP addresses
2. **IAM Roles:** Add proper EC2 instance roles
3. **Secrets Management:** Use AWS Secrets Manager
4. **Network ACLs:** Additional network security
5. **Security Groups:** More granular rules

This architecture provides a solid foundation for a production-ready Strapi deployment with room for future enhancements! 🚀
