# Hospital Service Comparison API

A RESTful backend API for comparing hospital services, prices, and ratings across different locations.

## 🚀 Features

* Hospital management with CRUD operations
* Medical service management
* Hospital-service relationship management
* Service price comparison
* Search, filtering, and sorting
* User authentication with JWT
* Role-based authorization
* Hospital reviews and ratings
* Input validation
* Centralized error handling
* API security with Helmet
* Rate limiting
* PostgreSQL database with foreign keys and constraints
* Database indexes for query optimization
* Production deployment with environment variables

## 🛠️ Tech Stack

* **Runtime:** Node.js
* **Framework:** Express.js
* **Database:** PostgreSQL
* **Authentication:** JWT
* **API Testing:** Postman
* **Security:** Helmet, express-rate-limit
* **Version Control:** Git & GitHub
* **Deployment:** Render

## 📁 Project Structure

```text
hospital-service-comparison/
├── SQL/
│   └── database.sql
├── src/
│   ├── config/
│   │   └── db.js
│   ├── controllers/
│   ├── middleware/
│   ├── routes/
│   └── server.js
├── .env
├── .gitignore
├── package.json
└── README.md
```

## 🔐 Authentication

The API uses JSON Web Tokens (JWT) for authentication.

Protected routes require a valid JWT token in the request:

```text
Authorization: Bearer <token>
```

Role-based authorization is used to restrict admin-only operations.

## 🔗 Main API Endpoints

### Hospitals

```text
GET    /api/hospitals
GET    /api/hospitals/:id
POST   /api/hospitals
PUT    /api/hospitals/:id
DELETE /api/hospitals/:id
```

### Services

```text
GET    /api/services
GET    /api/services/:id
POST   /api/services
PUT    /api/services/:id
DELETE /api/services/:id
```

### Service Comparison

```text
GET /api/comparisons/:service
GET /api/comparisons/:service/cheapest
GET /api/comparisons/:service/:location
```

### Hospital Services

```text
GET    /api/hospital-services
POST   /api/hospital-services
PUT    /api/hospital-services/:id
DELETE /api/hospital-services/:id
```

### Authentication

```text
POST /api/auth/register
POST /api/auth/login
```

### Profile

```text
GET /api/profile
```

### Reviews

```text
GET    /api/reviews/:hospitalId
POST   /api/reviews
PUT    /api/reviews/:id
DELETE /api/reviews/:id
```

## 🗄️ Database Design

The project uses PostgreSQL with relational tables for:

* Hospitals
* Services
* Hospital services
* Users
* Reviews

Foreign keys are used to maintain relationships between tables.

The `hospital_services` table acts as a relationship between hospitals and services and stores the price of each service.

Database constraints are used for data integrity, including:

* Primary keys
* Foreign keys
* Unique constraints
* Check constraints

Indexes are also used on frequently queried columns to improve database performance.

## 🧪 API Testing

API endpoints were tested using Postman.

Testing included:

* Successful requests
* Invalid input
* Missing fields
* Invalid IDs
* Duplicate records
* Authentication failures
* Authorization failures
* Database errors

## 🌐 Live API

The backend is deployed on Render.

**Base URL:**

https://hospital-service-comparison-edaj.onrender.com

Example:

```text
GET /api/hospitals
```

## ⚙️ Environment Variables

Create a `.env` file in the project root:

```env
DB_USER=your_database_user
DB_HOST=your_database_host
DB_NAME=hospital_service_comparison
DB_PASSWORD=your_database_password
DB_PORT=5432

JWT_SECRET=your_jwt_secret
```

Never commit `.env` or expose database credentials.

## ▶️ Run Locally

Clone the repository:

```bash
git clone https://github.com/Deepakgaikwad21/hospital-service-comparison.git
```

Install dependencies:

```bash
npm install
```

Configure the `.env` file.

Start the server:

```bash
node src/server.js
```

The API will run locally on:

```text
http://localhost:3000
```

## 📌 What I Learned

Through this project, I practiced:

* Building REST APIs with Node.js and Express.js
* Designing relational databases with PostgreSQL
* Writing SQL queries and JOINs
* Implementing JWT authentication
* Implementing role-based authorization
* Validating API input
* Handling errors
* Securing APIs
* Using database indexes
* Testing APIs with Postman
* Debugging production issues
* Deploying a backend application
* Managing production environment variables

## 👨‍💻 Author

**Deepak Gaikwad**

Backend Developer focused on Node.js, Express.js and PostgreSQL.
