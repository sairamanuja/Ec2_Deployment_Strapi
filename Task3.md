# Strapi + PostgreSQL + Nginx (Docker Deployment)

## 🚀 Overview
This project provides a fully containerized setup for running **Strapi CMS**, **PostgreSQL**, and **Nginx Reverse Proxy** using **Docker Compose**.

### Services Included
- **PostgreSQL 15 (Alpine)** – Database for Strapi  
- **Strapi CMS App** – Application backend  
- **Nginx** – Reverse proxy for HTTP traffic  
- **Persistent Volumes** – Database + uploads storage  
- **Common Network (`strapi-net`)** – All services communicate internally  


## ▶️ How to Run the Project

### Start all services:
```bash
docker compose up --build -d
```

### Access the application:
- **Strapi (via Nginx):** http://localhost
- **Strapi Admin Dashboard via http://localhost/admin.
---

# 🧱 Service Breakdown

## 1️⃣ PostgreSQL Database
Image: `postgres:15-alpine`

Environment variables:
```
POSTGRES_USER=strapi
POSTGRES_PASSWORD=strapi
POSTGRES_DB=strapi
```

Persistent storage:
```
postgres-data:/var/lib/postgresql/data
```

Connected to shared network:
```
strapi-net
```

---

## 2️⃣ Strapi Application
Built using your local Dockerfile:

```
build:
  context: .
```

Environment variables include database connection details and Strapi security keys.

Upload persistence:
```
./public/uploads:/app/public/uploads
```

Network:
```
strapi-net
```

---

## 3️⃣ Nginx Reverse Proxy
Routes all client traffic to Strapi.

Port mapping:
```
80:80
```

Loads config from:
```
./nginx.conf:/etc/nginx/nginx.conf
```

Network:
```
strapi-net
```

Nginx reaches Strapi internally at:
```
http://strapi:1337
```

---

# 🌐 Nginx Configuration

```nginx
events {}

http {
  server {
    listen 80;

    client_max_body_size 200M;

    location / {
      proxy_pass http://strapi:1337;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection "upgrade";
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
    }
  }
}


# 🔗 Common Docker Network: `strapi-net`

All services are connected to a single common Docker network:
```
strapi-net
```

Benefits:
- Secure internal communication  
- Services discover each other by name (`postgres`, `strapi`)  
- No need to expose internal ports  
- Cleaner architecture  

---

# 📦 Folder Structure

```
.
├── docker-compose.yml
├── Dockerfile
├── nginx.conf
├── public/
│   └── uploads/
└── src/
```

---

# 🛑 Stopping Services

Stop containers:
```bash
docker compose down
```

Stop + delete volumes (⚠ DB will be lost):
```bash
docker compose down -v
```

---

# 🔧 Rebuild After Changes

```bash
docker compose up --build -d
```

---

# ❓ Troubleshooting

### 502 Bad Gateway (Nginx)
Check Strapi logs:
```bash
docker compose logs strapi
```

### Database connection issues
```bash
docker compose logs postgres
```

### Upload errors
Check `client_max_body_size` in `nginx.conf`.

---


