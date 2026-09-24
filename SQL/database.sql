-- =========================================================
-- HOSPITAL SERVICE COMPARISON
-- DATABASE SQL FILE
-- =========================================================


-- =========================================================
-- DAY 1–2: DATABASE & TABLE SETUP
-- =========================================================


-- Create database
-- Run this separately if the database does not already exist:
-- CREATE DATABASE hospital_service_comparison;


-- Check current database
SELECT current_database();


-- =========================================================
-- DAY 2: HOSPITALS TABLE
-- =========================================================

CREATE TABLE hospitals (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL
);


-- =========================================================
-- DAY 2: INSERT HOSPITALS
-- =========================================================

INSERT INTO hospitals (name, location)
VALUES
('City Care Hospital', 'Pune'),
('LifeLine Hospital', 'Pune'),
('Sunrise Multispeciality Hospital', 'Mumbai'),
('Apollo Care Hospital', 'Mumbai'),
('Green Valley Hospital', 'Bangalore');


-- =========================================================
-- DAY 2: SERVICES TABLE
-- =========================================================

CREATE TABLE services (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(100) NOT NULL
);


-- =========================================================
-- DAY 2: INSERT SERVICES
-- =========================================================

INSERT INTO services (name, category)
VALUES
('MRI', 'Diagnostic'),
('CT Scan', 'Diagnostic'),
('X-Ray', 'Diagnostic'),
('Ultrasound', 'Diagnostic'),
('Blood Test', 'Laboratory'),
('ECG', 'Cardiology'),
('2D Echo', 'Cardiology'),
('Dialysis', 'Treatment');


-- =========================================================
-- DAY 2: HOSPITAL_SERVICES JUNCTION TABLE
-- =========================================================

CREATE TABLE hospital_services (
    id SERIAL PRIMARY KEY,
    hospital_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    price NUMERIC(10,2) NOT NULL,

    FOREIGN KEY (hospital_id)
        REFERENCES hospitals(id),

    FOREIGN KEY (service_id)
        REFERENCES services(id)
);


-- =========================================================
-- DAY 2: INSERT HOSPITAL-SERVICE RELATIONSHIPS
-- =========================================================

INSERT INTO hospital_services
(hospital_id, service_id, price)
VALUES
(1, 1, 5000),
(1, 2, 3000),
(1, 3, 800),
(1, 4, 1200),
(1, 5, 500),

(2, 1, 4500),
(2, 2, 2800),
(2, 3, 750),
(2, 4, 1000),
(2, 5, 450),

(3, 1, 5500),
(3, 2, 3200),
(3, 3, 900),
(3, 4, 1300),

(4, 1, 5200),
(4, 2, 3100),
(4, 3, 850),
(4, 6, 600),

(5, 1, 4800),
(5, 2, 2900),
(5, 3, 700),
(5, 7, 900);


-- =========================================================
-- DAY 2: BASIC SELECT QUERIES
-- =========================================================

-- Get all hospitals
SELECT * FROM hospitals;

-- Get all services
SELECT * FROM services;

-- Get all hospital-service relationships
SELECT * FROM hospital_services;

-- Get hospital names
SELECT name FROM hospitals;

-- Get hospitals in Mumbai
SELECT *
FROM hospitals
WHERE location = 'Mumbai';

-- Get services costing less than 1000
SELECT *
FROM hospital_services
WHERE price < 1000;


-- =========================================================
-- DAY 2: JOIN QUERIES
-- =========================================================

-- Show hospitals, services and prices
SELECT
    hospitals.name AS hospital,
    services.name AS service,
    hospital_services.price
FROM hospital_services
JOIN hospitals
    ON hospital_services.hospital_id = hospitals.id
JOIN services
    ON hospital_services.service_id = services.id;


-- =========================================================
-- DAY 2: SERVICE COMPARISON
-- =========================================================

-- Compare MRI prices
SELECT
    hospitals.name AS hospital,
    hospitals.location,
    services.name AS service,
    hospital_services.price
FROM hospital_services
JOIN hospitals
    ON hospital_services.hospital_id = hospitals.id
JOIN services
    ON hospital_services.service_id = services.id
WHERE services.name = 'MRI'
ORDER BY hospital_services.price ASC;


-- Compare MRI prices in Pune
SELECT
    hospitals.name AS hospital,
    hospitals.location,
    services.name AS service,
    hospital_services.price
FROM hospital_services
JOIN hospitals
    ON hospital_services.hospital_id = hospitals.id
JOIN services
    ON hospital_services.service_id = services.id
WHERE services.name = 'MRI'
AND hospitals.location = 'Pune'
ORDER BY hospital_services.price ASC;


-- Find cheapest MRI
SELECT
    hospitals.name AS hospital,
    hospital_services.price
FROM hospital_services
JOIN hospitals
    ON hospital_services.hospital_id = hospitals.id
JOIN services
    ON hospital_services.service_id = services.id
WHERE services.name = 'MRI'
ORDER BY hospital_services.price ASC
LIMIT 1;


-- Compare CT Scan prices
SELECT
    hospitals.name AS hospital,
    services.name AS service,
    hospital_services.price
FROM hospital_services
JOIN hospitals
    ON hospital_services.hospital_id = hospitals.id
JOIN services
    ON hospital_services.service_id = services.id
WHERE services.name = 'CT Scan'
ORDER BY hospital_services.price ASC;


-- Cheapest MRI in Pune
SELECT
    hospitals.name AS hospital,
    hospitals.location,
    services.name AS service,
    hospital_services.price
FROM hospital_services
JOIN hospitals
    ON hospital_services.hospital_id = hospitals.id
JOIN services
    ON hospital_services.service_id = services.id
WHERE services.name = 'MRI'
AND hospitals.location = 'Pune'
ORDER BY hospital_services.price ASC
LIMIT 1;



-- =========================================================
-- DAY 3: DATABASE PRACTICE QUERIES
-- =========================================================

-- Get hospitals from a specific location
SELECT *
FROM hospitals
WHERE location = 'Pune';


-- Get a hospital by ID
SELECT *
FROM hospitals
WHERE id = 1;


-- Get services from Diagnostic category
SELECT *
FROM services
WHERE category = 'Diagnostic';


-- Get services from Cardiology category
SELECT *
FROM services
WHERE category = 'Cardiology';


-- Get hospital services with price less than 1000
SELECT *
FROM hospital_services
WHERE price < 1000;


-- Get hospital services with price greater than 3000
SELECT *
FROM hospital_services
WHERE price > 3000;


-- Get hospitals sorted alphabetically
SELECT *
FROM hospitals
ORDER BY name ASC;


-- Get hospital services sorted by cheapest price
SELECT *
FROM hospital_services
ORDER BY price ASC;


-- Get hospital services sorted by highest price
SELECT *
FROM hospital_services
ORDER BY price DESC;


-- Count total hospitals
SELECT COUNT(*) AS total_hospitals
FROM hospitals;


-- Count total services
SELECT COUNT(*) AS total_services
FROM services;


-- Find the cheapest service price
SELECT MIN(price) AS cheapest_price
FROM hospital_services;


-- Find the highest service price
SELECT MAX(price) AS highest_price
FROM hospital_services;


-- Find the average service price
SELECT AVG(price) AS average_price
FROM hospital_services;



-- =========================================================
-- DAY 4: UNIQUE CONSTRAINT
-- =========================================================

-- Prevent duplicate hospital-service combinations

ALTER TABLE hospital_services
ADD CONSTRAINT unique_hospital_service
UNIQUE (hospital_id, service_id);


-- =========================================================
-- DAY 4: CHECK CONSTRAINT
-- =========================================================

-- Prevent negative prices

ALTER TABLE hospital_services
ADD CONSTRAINT price_positive
CHECK (price >= 0);


-- =========================================================
-- DAY 4: CHECK CONSTRAINT TEST
-- =========================================================

-- This should FAIL because price cannot be negative.
-- Do NOT execute unless you want to test the constraint.

-- INSERT INTO hospital_services
-- (hospital_id, service_id, price)
-- VALUES
-- (1, 1, -500);


-- =========================================================
-- DAY 4: UNIQUE CONSTRAINT TEST
-- =========================================================

-- This should FAIL because (1,1) already exists.
-- Do NOT execute unless you want to test the constraint.

-- INSERT INTO hospital_services
-- (hospital_id, service_id, price)
-- VALUES
-- (1, 1, 6000);


-- =========================================================
-- DAY 4: CHECK TABLE CONSTRAINTS
-- =========================================================

SELECT
    constraint_name,
    constraint_type
FROM information_schema.table_constraints
WHERE table_name = 'hospital_services';


-- =========================================================
-- DAY 4: CHECK TABLE COLUMNS
-- =========================================================

SELECT
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'hospital_services';


-- =========================================================
-- DAY 5: ON DELETE CASCADE
-- =========================================================

-- Remove the existing hospital_id foreign key
-- and recreate it with ON DELETE CASCADE.


ALTER TABLE hospital_services
DROP CONSTRAINT hospital_services_hospital_id_fkey;


ALTER TABLE hospital_services
ADD CONSTRAINT hospital_services_hospital_id_fkey
FOREIGN KEY (hospital_id)
REFERENCES hospitals(id)
ON DELETE CASCADE;


-- Remove the existing service_id foreign key
-- and recreate it with ON DELETE CASCADE.

ALTER TABLE hospital_services
DROP CONSTRAINT hospital_services_service_id_fkey;


ALTER TABLE hospital_services
ADD CONSTRAINT hospital_services_service_id_fkey
FOREIGN KEY (service_id)
REFERENCES services(id)
ON DELETE CASCADE;


-- =========================================================
-- DAY 5: CHECK FOREIGN KEY CONSTRAINTS
-- =========================================================

SELECT
    constraint_name
FROM information_schema.table_constraints
WHERE table_name = 'hospital_services'
AND constraint_type = 'FOREIGN KEY';


-- =========================================================
-- DAY 5: INDEXES
-- =========================================================

-- Index for searching services by name
CREATE INDEX idx_services_name
ON services(name);


-- Index for searching hospitals by location
CREATE INDEX idx_hospitals_location
ON hospitals(location);


-- Index for finding services belonging to a hospital
CREATE INDEX idx_hospital_services_hospital_id
ON hospital_services(hospital_id);


-- Index for finding hospitals offering a service
CREATE INDEX idx_hospital_services_service_id
ON hospital_services(service_id);


-- =========================================================
-- DAY 5: CHECK INDEXES
-- =========================================================

SELECT
    indexname,
    indexdef
FROM pg_indexes
WHERE tablename = 'hospitals';


SELECT
    indexname,
    indexdef
FROM pg_indexes
WHERE tablename = 'services';


SELECT
    indexname,
    indexdef
FROM pg_indexes
WHERE tablename = 'hospital_services';



-- =========================
-- DAY 7: HOSPITAL CRUD
-- =========================

-- Create hospital
INSERT INTO hospitals (name, location)
VALUES ('New Care Hospital', 'Pune')
RETURNING *;

-- Get all hospitals
SELECT * FROM hospitals;

-- Get hospital by ID
SELECT * FROM hospitals
WHERE id = 1;

-- Update hospital
UPDATE hospitals
SET name = 'Updated Care Hospital',
    location = 'Mumbai'
WHERE id = 1
RETURNING *;

-- Delete hospital
DELETE FROM hospitals
WHERE id = 1
RETURNING *;



-- =========================
-- DAY 8: SERVICE CRUD
-- =========================

-- Create service
INSERT INTO services (name, category)
VALUES ('PET Scan', 'Diagnostic')
RETURNING *;

-- Get all services
SELECT * FROM services;

-- Get service by ID
SELECT * FROM services
WHERE id = 1;

-- Update service
UPDATE services
SET name = 'Advanced MRI',
    category = 'Diagnostic'
WHERE id = 1
RETURNING *;

-- Delete service
DELETE FROM services
WHERE id = 1
RETURNING *;




-- =========================
-- DAY 9: HOSPITAL-SERVICE APIs
-- =========================

-- Create hospital-service relationship
INSERT INTO hospital_services
(hospital_id, service_id, price)
VALUES
(2, 6, 700)
RETURNING *;

-- Get all hospital-service relationships
SELECT *
FROM hospital_services;

-- Get detailed hospital-service information
SELECT
    hospital_services.id,
    hospitals.name AS hospital,
    services.name AS service,
    hospital_services.price
FROM hospital_services
JOIN hospitals
    ON hospital_services.hospital_id = hospitals.id
JOIN services
    ON hospital_services.service_id = services.id
ORDER BY hospital_services.id;

-- Get services provided by a hospital
SELECT
    hospitals.name AS hospital,
    services.name AS service,
    hospital_services.price
FROM hospital_services
JOIN hospitals
    ON hospital_services.hospital_id = hospitals.id
JOIN services
    ON hospital_services.service_id = services.id
WHERE hospitals.id = 2
ORDER BY services.name;

-- Get hospitals providing a service
SELECT
    hospitals.name AS hospital,
    services.name AS service,
    hospital_services.price
FROM hospital_services
JOIN hospitals
    ON hospital_services.hospital_id = hospitals.id
JOIN services
    ON hospital_services.service_id = services.id
WHERE services.id = 2
ORDER BY hospital_services.price ASC;


-- =========================
-- DAY 10: SEARCH & FILTERING
-- =========================

-- Get hospitals by location
SELECT *
FROM hospitals
WHERE location = 'Pune';

-- Search hospitals by name
SELECT *
FROM hospitals
WHERE name ILIKE '%Care%';

-- Search hospitals by name and location
SELECT *
FROM hospitals
WHERE location = 'Pune'
AND name ILIKE '%Care%';

-- Search hospitals containing a word
SELECT *
FROM hospitals
WHERE name ILIKE '%Hospital%';

-- Get hospitals from Mumbai
SELECT *
FROM hospitals
WHERE location = 'Mumbai';

-- Compare service prices
SELECT
    hospitals.name AS hospital,
    hospitals.location,
    services.name AS service,
    hospital_services.price
FROM hospital_services
JOIN hospitals
    ON hospital_services.hospital_id = hospitals.id
JOIN services
    ON hospital_services.service_id = services.id
WHERE services.name = 'CT Scan'
ORDER BY hospital_services.price ASC;

-- Find cheapest hospital for a service
SELECT
    hospitals.name AS hospital,
    hospitals.location,
    services.name AS service,
    hospital_services.price
FROM hospital_services
JOIN hospitals
    ON hospital_services.hospital_id = hospitals.id
JOIN services
    ON hospital_services.service_id = services.id
WHERE services.name = 'CT Scan'
ORDER BY hospital_services.price ASC
LIMIT 1;



-- =========================
-- DAY 11: ADVANCED FILTERING
-- =========================

-- Filter by maximum price
SELECT
    hospitals.name AS hospital,
    hospitals.location,
    services.name AS service,
    hospital_services.price
FROM hospital_services
JOIN hospitals
    ON hospital_services.hospital_id = hospitals.id
JOIN services
    ON hospital_services.service_id = services.id
WHERE services.name = 'CT Scan'
AND hospital_services.price <= 3000
ORDER BY hospital_services.price ASC;


-- Filter by price range
SELECT
    hospitals.name AS hospital,
    hospitals.location,
    services.name AS service,
    hospital_services.price
FROM hospital_services
JOIN hospitals
    ON hospital_services.hospital_id = hospitals.id
JOIN services
    ON hospital_services.service_id = services.id
WHERE services.name = 'CT Scan'
AND hospital_services.price >= 2000
AND hospital_services.price <= 3000
ORDER BY hospital_services.price ASC;


-- Sort cheapest to most expensive
SELECT *
FROM hospital_services
ORDER BY price ASC;


-- Sort most expensive to cheapest
SELECT *
FROM hospital_services
ORDER BY price DESC;


-- Pagination: first 2 records
SELECT *
FROM hospital_services
ORDER BY price ASC
LIMIT 2
OFFSET 0;


-- Pagination: next 2 records
SELECT *
FROM hospital_services
ORDER BY price ASC
LIMIT 2
OFFSET 2;


-- =========================
-- DAY 12: AUTHENTICATION
-- =========================

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- =========================
-- DAY 13: AUTHORIZATION
-- =========================

-- Update user role to admin
UPDATE users
SET role = 'admin'
WHERE email = 'deepak@gmail.com';

-- Check user role
SELECT id, name, email, role
FROM users;

-- Example: change admin back to normal user
-- UPDATE users
-- SET role = 'user'
-- WHERE email = 'deepak@gmail.com';


-- =========================
-- DAY 14: REVIEWS & RATINGS
-- =========================

CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    hospital_id INTEGER NOT NULL,
    rating INTEGER NOT NULL,
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    FOREIGN KEY (hospital_id)
        REFERENCES hospitals(id)
        ON DELETE CASCADE,

    CHECK (rating >= 1 AND rating <= 5)
);


-- =========================
-- DAY 15: REVIEW CRUD & OWNERSHIP
-- =========================

-- View all reviews
SELECT *
FROM reviews;

-- View reviews with user and hospital information
SELECT
    reviews.id,
    users.name AS user,
    hospitals.name AS hospital,
    reviews.rating,
    reviews.comment,
    reviews.created_at
FROM reviews
JOIN users
    ON reviews.user_id = users.id
JOIN hospitals
    ON reviews.hospital_id = hospitals.id
ORDER BY reviews.created_at DESC;

-- Check review ownership
SELECT
    id,
    user_id,
    hospital_id,
    rating,
    comment
FROM reviews
WHERE id = 1;

-- Example: update a review
-- UPDATE reviews
-- SET rating = 4,
--     comment = 'Good service'
-- WHERE id = 1
-- AND user_id = 1;

-- Example: delete a review
-- DELETE FROM reviews
-- WHERE id = 1
-- AND user_id = 1;


-- =========================
-- DAY 16: VALIDATION & ERROR HANDLING
-- =========================

-- Check reviews with their ratings
SELECT
    id,
    user_id,
    hospital_id,
    rating,
    comment
FROM reviews;

-- Check ratings outside the valid range
-- This should return 0 rows because of the CHECK constraint
SELECT *
FROM reviews
WHERE rating < 1
   OR rating > 5;

-- Check hospitals with invalid IDs in reviews
SELECT
    reviews.id,
    reviews.hospital_id
FROM reviews
LEFT JOIN hospitals
    ON reviews.hospital_id = hospitals.id
WHERE hospitals.id IS NULL;


-- =========================
-- DAY 17: API SECURITY
-- =========================

-- Check that review ratings are within the allowed range
SELECT *
FROM reviews
WHERE rating < 1
   OR rating > 5;

-- Check hospital-service prices are valid
SELECT *
FROM hospital_services
WHERE price < 0;

-- Check duplicate hospital-service relationships
SELECT hospital_id, service_id, COUNT(*)
FROM hospital_services
GROUP BY hospital_id, service_id
HAVING COUNT(*) > 1;


-- =========================
-- DAY 18: ADVANCED SQL & OPTIMIZATION
-- =========================

-- Check query execution plan
EXPLAIN
SELECT *
FROM hospitals
WHERE location = 'Pune';

-- Check actual query performance
EXPLAIN ANALYZE
SELECT *
FROM hospitals
WHERE location = 'Pune';

-- Check service filtering and sorting performance
EXPLAIN ANALYZE
SELECT *
FROM hospital_services
WHERE service_id = 6
ORDER BY price ASC;

-- Composite index for service filtering + price sorting
CREATE INDEX idx_hospital_services_service_price
ON hospital_services(service_id, price);

-- View indexes on hospital_services
SELECT indexname
FROM pg_indexes
WHERE tablename = 'hospital_services';