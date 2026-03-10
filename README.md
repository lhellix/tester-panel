# Tester Panel Backend API

## Overview
RESTful API for Tester Panel built with Node.js, Express, MySQL, and JWT authentication.

## Tech Stack
- **Runtime:** Node.js
- **Framework:** Express.js
- **Database:** MySQL
- **Authentication:** JWT
- **Security:** Bcrypt, Helmet, CORS

## Installation

### Prerequisites
- Node.js >= 14
- MySQL >= 5.7
- npm or yarn

### Setup

1. Install dependencies:
```bash
npm install
```

2. Create `.env` file with your configuration:
```
PORT=3000
NODE_ENV=development
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=password
DB_NAME=tester_panel
JWT_SECRET=your_jwt_secret_key
JWT_EXPIRY=7d
CORS_ORIGIN=http://localhost:3000
```

3. Initialize database:
```bash
npm run init-db
```

4. Start the server:
```bash
npm run dev
```

## API Endpoints

### Health Check
- `GET /api/health` - Server status

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user

### Users
- `GET /api/users` - Get all users (requires auth)
- `GET /api/users/:id` - Get user by ID (requires auth)
- `GET /api/users/profile/me` - Get current user (requires auth)
- `PUT /api/users/:id` - Update user (requires auth)
- `DELETE /api/users/:id` - Delete user (requires auth)

### Items
- `POST /api/items` - Create item (requires auth)
- `GET /api/items` - Get all items (requires auth)
- `GET /api/items/:id` - Get item by ID (requires auth)
- `GET /api/items/user/:userId` - Get items by user (requires auth)
- `PUT /api/items/:id` - Update item (requires auth)
- `DELETE /api/items/:id` - Delete item (requires auth)

## Request Examples

### Register
```bash
POST /api/auth/register
{
  "email": "user@example.com",
  "password": "password123",
  "name": "John Doe"
}
```

### Login
```bash
POST /api/auth/login
{
  "email": "user@example.com",
  "password": "password123"
}
```

### Create Item
```bash
POST /api/items
Authorization: Bearer <token>
{
  "title": "My first item",
  "description": "Description here",
  "status": "pending"
}
```

## Authentication

All protected endpoints require JWT token in Authorization header:
```
Authorization: Bearer <your_jwt_token>
```

## Error Handling

Returns standard HTTP status codes with error messages:
- `200` - Success
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `409` - Conflict
- `500` - Internal Server Error

## Database Schema

### Users Table
```sql
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  role ENUM('admin', 'user') DEFAULT 'user',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### Items Table
```sql
CREATE TABLE items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  status ENUM('pending', 'in_progress', 'completed') DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

## Deployment

### Docker
Create `Dockerfile`:
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

### Railway
```bash
railway link
railway up
```

### Heroku
```bash
heroku create your-app-name
git push heroku main
```

## Testing

```bash
npm test
```

## License

MIT
