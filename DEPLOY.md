# Deploy Guide

## Local Development

### Using Node.js directly
```bash
# Install dependencies (if not done yet)
npm install

# Start development server with auto-reload
npm run dev

# Server will run on http://localhost:3000
```

### Using Docker Compose
```bash
# Build and start containers
docker-compose up

# Server will run on http://localhost:3000
# MySQL will run on localhost:3306
```

---

## Railway (Recommended - Free tier available)

### Setup

1. **Create Railway account** at [railway.app](https://railway.app)

2. **Install Railway CLI:**
```bash
npm install -g @railway/cli
```

3. **Login to Railway:**
```bash
railway login
```

4. **Initialize project:**
```bash
railway init
```

5. **Add MySQL database:**
```bash
railway add
# Select MySQL from the list
```

6. **Configure environment:**
```bash
railway variables
# Set:
# - JWT_SECRET=your-secret-key
# - NODE_ENV=production
# - CORS_ORIGIN=your-domain.com
```

7. **Deploy:**
```bash
railway up
```

---

## Heroku

### Setup

1. **Create Heroku account** at [heroku.com](https://heroku.com)

2. **Install Heroku CLI:**
```bash
npm install -g heroku
```

3. **Login:**
```bash
heroku login
```

4. **Create app:**
```bash
heroku create your-app-name
```

5. **Add MySQL add-on:**
```bash
heroku addons:create cleardb:ignite
```

6. **Set environment variables:**
```bash
heroku config:set JWT_SECRET=your-secret-key
heroku config:set NODE_ENV=production
```

7. **Deploy:**
```bash
git push heroku main
```

8. **View logs:**
```bash
heroku logs --tail
```

---

## GitHub Actions CI/CD

The project includes automatic testing and deployment on push to `main` branch.

Setup:

1. **Push to GitHub**
2. **Add secrets in repository settings:**
   - `RAILWAY_TOKEN` - Get from Railway dashboard
   - `HEROKU_API_KEY` - Get from Heroku account settings

3. **Push to main branch** to trigger deployment

---

## Docker Deployment (VPS/Cloud)

### Build Docker image
```bash
docker build -t tester-panel-backend .
```

### Run with external MySQL
```bash
docker run -d \
  --name backend \
  -p 3000:3000 \
  -e DB_HOST=your-mysql-host \
  -e DB_USER=user \
  -e DB_PASSWORD=password \
  -e JWT_SECRET=your-secret \
  tester-panel-backend
```

### Using Docker Hub
```bash
docker tag tester-panel-backend your-username/tester-panel-backend
docker push your-username/tester-panel-backend
```

---

## Environment Variables

| Variable | Example | Required | Description |
|----------|---------|----------|-------------|
| PORT | 3000 | No | Server port |
| NODE_ENV | production | No | Environment |
| DB_HOST | db.example.com | Yes | MySQL host |
| DB_PORT | 3306 | No | MySQL port |
| DB_USER | root | Yes | MySQL user |
| DB_PASSWORD | password | Yes | MySQL password |
| DB_NAME | tester_panel | No | Database name |
| JWT_SECRET | your-secret | Yes | JWT signing secret |
| JWT_EXPIRY | 7d | No | Token expiry |
| CORS_ORIGIN | example.com | No | CORS allowed origins |

---

## Health Check

After deployment, verify API is working:

```bash
curl https://your-api-url/api/health
```

Expected response:
```json
{
  "status": "Server is running",
  "timestamp": "2024-03-10T..."
}
```

---

## Troubleshooting

### Database connection failed
- Check DB credentials in .env
- Ensure MySQL is running and accessible
- Check firewall rules

### 401 Unauthorized
- Make sure JWT_SECRET is set correctly
- Verify token is being sent in Authorization header

### CORS errors
- Update CORS_ORIGIN in environment variables
- Include protocol (http:// or https://)

### Application won't start
- Check logs: `heroku logs --tail` or `railway up`
- Verify all required environment variables are set
- Ensure database initialization completes successfully
