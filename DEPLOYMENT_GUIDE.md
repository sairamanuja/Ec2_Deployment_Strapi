# GitHub Actions CI/CD Setup for Strapi

Simple CI/CD pipeline to deploy Strapi application to AWS EC2 using Docker and Terraform.

## Required GitHub Secrets

Go to Repository → Settings → Secrets and variables → Actions

```
DOCKERHUB_USERNAME    # Your Docker Hub username
DOCKERHUB_TOKEN       # Docker Hub access token
AWS_ACCESS_KEY_ID     # AWS access key
AWS_SECRET_ACCESS_KEY # AWS secret key
```

## Setup Steps

### 1. Docker Hub Token
- Go to Docker Hub → Account Settings → Security
- Create New Access Token
- Add as `DOCKERHUB_TOKEN` secret

### 2. AWS Setup
- Create IAM user with EC2/VPC permissions
- Create EC2 Key Pair named `strapi-deployment-key`
- Add AWS credentials as secrets

### 3. Deploy Application

**Step 1: Push code to trigger build**
```bash
git push origin main
```
This builds and pushes Docker image to Docker Hub.

**Step 2: Deploy to AWS**
- Go to Actions → "Deploy to AWS EC2"
- Click "Run workflow"
- Enter Docker image: `username/strapi-app:main-abc1234`
- Select action: `apply`
- Run workflow

**Step 3: Access Application**
After deployment, get the public IP from workflow output:
- Admin: `http://PUBLIC_IP:1337/admin`
- API: `http://PUBLIC_IP:1337/api`
- SSH: `ssh -i key.pem ubuntu@PUBLIC_IP`

## Troubleshooting

**Docker build fails:**
- Check Dockerfile and dependencies

**AWS deployment fails:**
- Verify AWS credentials and permissions
- Check if key pair exists

**App not accessible:**
- SSH to server and check: `docker ps` and `docker logs strapi-app`