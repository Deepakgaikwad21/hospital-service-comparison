const pool = require("../config/db");

const compareServices = async (req, res) => {
    try {
        const serviceName = req.params.service;

        const {
            location,
            minPrice,
            maxPrice,
            page = 1,
            limit = 5,
            sort = "asc"
        } = req.query;

        const offset = (page - 1) * limit;

        let query = `
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
            WHERE LOWER(services.name) = LOWER($1)
        `;

        const values = [serviceName];

        if (location) {
            values.push(location);

            query += `
                AND LOWER(hospitals.location) = LOWER($${values.length})
            `;
        }

        if (minPrice) {
            values.push(minPrice);

            query += `
                AND hospital_services.price >= $${values.length}
            `;
        }

        if (maxPrice) {
            values.push(maxPrice);

            query += `
                AND hospital_services.price <= $${values.length}
            `;
        }

        const sortOrder =
            sort.toLowerCase() === "desc" ? "DESC" : "ASC";

        query += `
            ORDER BY hospital_services.price ${sortOrder}
            LIMIT $${values.length + 1}
            OFFSET $${values.length + 2}
        `;

        values.push(limit, offset);

        const result = await pool.query(query, values);

        res.json(result.rows);

    } catch (error) {
        console.error(error);

        res.status(500).json({
            message: "Internal server error"
        });
    }
};

//Get Cheapest Service
const getCheapestService = async (req, res) => {
    try {
        const serviceName = req.params.service;
        const { location } = req.query;

        let query = `
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
            WHERE LOWER(services.name) = LOWER($1)
        `;

        const values = [serviceName];

        if (location) {
            values.push(location);

            query += `
                AND LOWER(hospitals.location) = LOWER($${values.length})
            `;
        }

        query += `
            ORDER BY hospital_services.price ASC
            LIMIT 1
        `;

        const result = await pool.query(query, values);

        if (result.rows.length === 0) {
            return res.status(404).json({
                message: "No matching service found"
            });
        }

        res.json(result.rows[0]);

    } catch (error) {
        console.error(error);

        res.status(500).json({
            message: "Internal server error"
        });
    }
};


module.exports = {
    compareServices, getCheapestService
};