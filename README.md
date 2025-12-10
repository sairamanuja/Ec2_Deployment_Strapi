# Strapi Application Setup Guide

This guide provides step-by-step instructions to set up a Strapi application from scratch, including creating content types, configuring the database, and running the application in both development and production modes.

## Prerequisites

Before creating a Strapi application, ensure you have:

- **Node.js**: Version 20.x or higher (up to 24.x)
- **npm**: Version 6.0.0 or higher
- **A code editor**: VS Code, Sublime Text, etc.

Check your installed versions:
```bash
node --version
npm --version
```

---

## Creating a New Strapi Application

### Step 1: Install Strapi CLI (Optional)
```bash
npm install -g @strapi/strapi
```

### Step 2: Create a New Project

There are two main ways to create a Strapi project:

#### Option A: Using npx (Recommended)
```bash
npx create-strapi-app@latest my-strapi-project
```

#### Option B: Using Strapi CLI
```bash
strapi new my-strapi-project
```

### Step 3: Choose Your Setup

During installation, you'll be prompted to choose:

1. **Installation Type**:
   - **Quickstart** (recommended): Uses SQLite database
   - **Custom**: Choose your own database (PostgreSQL, MySQL, MariaDB, SQLite)

2. **For Custom Installation**, configure:
   - Database type (PostgreSQL, MySQL, SQLite)
   - Database credentials
   - Database name

**Example for this project** (Quickstart with SQLite):
```bash
npx create-strapi-app@latest my-strapi --quickstart
```

### Step 4: Navigate to Project Directory
```bash
cd my-strapi-project
```

---

## Project Structure

After creation, your Strapi project will have this structure:

```
my-strapi-project/
├── config/              # Configuration files
│   ├── admin.js         # Admin panel configuration
│   ├── api.js           # API configuration
│   ├── database.js      # Database configuration
│   ├── middlewares.js   # Middleware configuration
│   ├── plugins.js       # Plugins configuration
│   └── server.js        # Server configuration
├── database/            # Database files
│   └── migrations/      # Database migrations
├── public/              # Public assets
│   └── uploads/         # Uploaded files
├── src/
│   ├── admin/           # Admin panel customization
│   ├── api/             # API endpoints and content types
│   ├── components/      # Reusable components
│   ├── extensions/      # Plugin extensions
│   └── index.js         # Entry point
├── .env                 # Environment variables
├── package.json         # Dependencies and scripts
└── README.md           # Project documentation
```

---

## Running the Application

### Development Mode (with auto-reload)

Start the development server with hot-reloading enabled:

```bash
npm run develop
```

Or:
```bash
yarn develop
```

**What happens:**
- Strapi server starts on `http://localhost:1337`
- Admin panel available at `http://localhost:1337/admin`
- Auto-reload enabled (changes trigger automatic restart)
- First-time users will be prompted to create an admin account

### Production Mode

First, build the admin panel:
```bash
npm run build
```

Then start the server:
```bash
npm run start
```

**Differences from Development Mode:**
- No auto-reload
- Optimized performance
- Built admin panel served as static files

### Other Useful Commands

```bash
# Open Strapi console
npm run console

# Deploy to Strapi Cloud
npm run deploy

# Run seed script (if available)
npm run seed:example
```

---

## Creating Content Types

### Method 1: Using Admin Panel (Recommended for Beginners)

1. Start the development server:
   ```bash
   npm run develop
   ```

2. Open `http://localhost:1337/admin` in your browser

3. Create admin account (first time only)

4. Navigate to **Content-Type Builder** in the left sidebar

5. Click **"Create new collection type"**

6. Configure your content type:
   - **Display name**: e.g., "Article"
   - **API ID (singular)**: e.g., "article"
   - **API ID (plural)**: e.g., "articles"

7. Add fields to your content type:
   - Click **"Add another field"**
   - Choose field type (Text, Rich text, Number, Date, Media, Relation, etc.)
   - Configure field settings
   - Click **"Finish"** and **"Save"**

8. Strapi will restart automatically

### Method 2: Manual Creation (Advanced)

Create a schema file manually:

```bash
# Create directory structure
mkdir -p src/api/article/content-types/article

# Create schema.json file
```

Example `src/api/article/content-types/article/schema.json`:
```json
{
  "kind": "collectionType",
  "collectionName": "articles",
  "info": {
    "singularName": "article",
    "pluralName": "articles",
    "displayName": "Article"
  },
  "options": {
    "draftAndPublish": true
  },
  "attributes": {
    "title": {
      "type": "string",
      "required": true
    },
    "description": {
      "type": "text"
    },
    "content": {
      "type": "richtext"
    },
    "slug": {
      "type": "uid",
      "targetField": "title"
    },
    "cover": {
      "type": "media",
      "multiple": false,
      "allowedTypes": ["images"]
    },
    "author": {
      "type": "relation",
      "relation": "manyToOne",
      "target": "api::author.author",
      "inversedBy": "articles"
    }
  }
}
```

---

## Database Configuration

### Default Configuration (SQLite)

By default, Strapi uses SQLite with the configuration in `config/database.js`:

```javascript
sqlite: {
  connection: {
    filename: path.join(__dirname, '..', env('DATABASE_FILENAME', '.tmp/data.db')),
  },
  useNullAsDefault: true,
}
```

### Switching to PostgreSQL

1. Install PostgreSQL client:
```bash
npm install pg
```

2. Update `.env` file:
```env
DATABASE_CLIENT=postgres
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_NAME=strapi
DATABASE_USERNAME=strapi_user
DATABASE_PASSWORD=your_password
DATABASE_SSL=false
```

3. The `config/database.js` will automatically use these environment variables

### Switching to MySQL

1. Install MySQL client:
```bash
npm install mysql2
```

2. Update `.env` file:
```env
DATABASE_CLIENT=mysql
DATABASE_HOST=localhost
DATABASE_PORT=3306
DATABASE_NAME=strapi
DATABASE_USERNAME=strapi_user
DATABASE_PASSWORD=your_password
DATABASE_SSL=false
```

---

## First-Time Setup Checklist

- [ ] Install Node.js (v20+)
- [ ] Create Strapi project using `npx create-strapi-app`
- [ ] Navigate to project directory
- [ ] Run `npm run develop`
- [ ] Access admin panel at `http://localhost:1337/admin`
- [ ] Create admin user account
- [ ] Create your first content type
- [ ] Configure API permissions in Settings > Roles > Public
- [ ] Test API endpoints at `http://localhost:1337/api/<content-type>`
- [ ] Start building your application!

---

## Common Commands Reference

```bash
# Development
npm run develop          # Start with auto-reload

# Production
npm run build           # Build admin panel
npm run start           # Start production server

# Other
npm run console         # Open Strapi console
npm run strapi          # Run Strapi CLI commands
npm run deploy          # Deploy to Strapi Cloud
```

---

## Accessing Your API

Once your content types are created and permissions are set:

- **API Base URL**: `http://localhost:1337/api`
- **Example endpoints**:
  - GET all articles: `http://localhost:1337/api/articles`
  - GET single article: `http://localhost:1337/api/articles/1`
  - POST new article: `http://localhost:1337/api/articles`

---

## Troubleshooting

### Port Already in Use
If port 1337 is busy:
```bash
# Set custom port in .env
HOST=0.0.0.0
PORT=1338
```

### Database Connection Issues
- Check database credentials in `.env`
- Ensure database server is running
- Verify firewall settings

### Permission Errors
- Configure public/authenticated roles in Settings > Users & Permissions plugin
- Enable find/findOne actions for public access

---



# 🐳 Strapi Docker Setup – Task 2


---

## 📁 1. Dockerfile

```dockerfile
FROM node:20-alpine

RUN apk add --no-cache build-base gcc autoconf automake libtool pkgconfig python3

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 1337

CMD ["npm", "run", "develop"]
```

### ✔ Explanation

- Uses lightweight **Node.js 20 Alpine**  
- Installs required native build tools  
- Sets `/app` as working directory  
- Installs dependencies  
- Copies entire project inside image  
- Exposes port **1337**  
- Starts Strapi in **development mode**

---

## 🐳 2. docker-compose.yml

```yaml
services:
  strapi:
    build:
      context: .

    ports:
      - '1337:1337'
    environment:
      DATABASE_CLIENT: sqlite
      DATABASE_FILENAME: .tmp/data.db
      HOST: 0.0.0.0
      PORT: 1337
      APP_KEYS: OHVlPIaL+rjoPlAYBKPsbA==,BCY7wTL9X6DeAzkMUh1m+Q==,T+12wp9uvTkcLVcUAkpY6w==,VB7j4EEVVmutyc+UwjHC4A==
      API_TOKEN_SALT: 1gFG5dUJtfipGOQaVf65jA==
      ADMIN_JWT_SECRET: loG6V62RTsOTuGLioemtHw==
      TRANSFER_TOKEN_SALT: c4UML4TE733e7ApvWFiyTw==
      JWT_SECRET: loG6V62RTsOTuGLioemtHw==
      ENCRYPTION_KEY: YQToCNDnkNhkL5p2buxZNA==
    volumes:
      - .:/app
      - /app/node_modules
      - ./public/uploads:/app/public/uploads
      - strapi-data:/app/.tmp

volumes:
  strapi-data:
```

### ✔ Explanation

- Automatically builds the image from the Dockerfile  
- Maps **1337 → 1337** for local access  
- Provides required Strapi environment variables  
- Mounts project directory for **live reload**  
- Persists uploads & SQLite DB using volumes  

---

## 📦 3. .dockerignore

```
node_modules
npm-debug.log
```

This reduces Docker build size and improves performance.

---

## ▶️ 4. Build & Run With Docker (Without Compose)

### Build Image
```bash
docker build -t my-strapi-app .
```

### Run Container
```bash
docker run -p 1337:1337 my-strapi-app
```

### View Logs
```bash
docker logs <container-id>
```

### Follow Logs (Live)
```bash
docker logs -f <container-id>
```

---

## ▶️ 5. Build & Run With Docker Compose

### Start Services
```bash
docker compose up --build
```

### Run in Background
```bash
docker compose up -d
```

### Stop Services
```bash
docker compose down
```

### View Logs
```bash
docker compose logs
```

### Follow Logs (Live)
```bash
docker compose logs -f strapi
```

---

## 🔍 6. Difference Between `docker run` and Docker Compose

| Feature | `docker run` | Docker Compose |
|--------|--------------|----------------|
| Usage | Runs a single container manually | Manages multi-container apps |
| Configuration | All flags set manually | Uses `docker-compose.yml` |
| Environment variables | Passed each time | Stored in YAML |
| Volumes & ports | Must be manually added | Predefined in YAML |
| Scaling | Limited | Easy (`docker compose up --scale`) |
| Best for | Quick testing | Development environments |

### 👉 In simple terms:
- **Use `docker run` for simple one-off containers.**  
- **Use Docker Compose for real development work and multi-container setups.**

---

## 🌐 7. Access the Strapi Application

Once running, open:

👉 **http://localhost:1337**

This will open the Strapi Admin Panel.

# Ec2_Deployment_Strapi
