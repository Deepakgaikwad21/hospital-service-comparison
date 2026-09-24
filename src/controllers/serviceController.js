const pool = require("../config/db");

const getServices = async (req, res) => {
    try {
        const { category, name } = req.query;

        let query = "SELECT * FROM services WHERE 1=1";
        const values = [];

        if (category) {
            values.push(category);
            query += ` AND LOWER(category) = LOWER($${values.length})`;
        }

        if (name) {
            values.push(`%${name}%`);
            query += ` AND name ILIKE $${values.length}`;
        }

        const result = await pool.query(query, values);

        res.json(result.rows);

    } catch (error) {
        console.error(error);

        res.status(500).json({
            message: "Internal server error"
        });
    }
};
// create service
const createService = async (req, res) => {
    try {
        const { name, category } = req.body;
        if (!name || !category) {
    return res.status(400).json({
        message: "name and category are required"
    });
}

        const result = await pool.query(
            `INSERT INTO services (name, category)
             VALUES ($1, $2)
             RETURNING *`,
            [name, category]
        );

        res.status(201).json(result.rows[0]);

    } catch (error) {
        console.error(error);

        res.status(500).json({
            message: "Internal server error"
        });
    }
};
//get service by id
const getServiceById = async (req, res) => {
    try {
        const serviceId = req.params.id;

        const result = await pool.query(
            "SELECT * FROM services WHERE id = $1",
            [serviceId]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({
                message: "Service not found"
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

// update service
const updateService = async (req, res) => {
    try {
        const serviceId = req.params.id;
        const { name, category } = req.body;

        if (!name || !category) {
            return res.status(400).json({
                message: "name and category are required"
            });
        }

        const result = await pool.query(
            `UPDATE services
             SET name = $1, category = $2
             WHERE id = $3
             RETURNING *`,
            [name, category, serviceId]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({
                message: "Service not found"
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
//Delete service
const deleteService = async (req, res) => {
    try {
        const serviceId = req.params.id;

        const result = await pool.query(
            "DELETE FROM services WHERE id = $1 RETURNING *",
            [serviceId]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({
                message: "Service not found"
            });
        }

        res.json({
            message: "Service deleted successfully",
            service: result.rows[0]
        });

    } catch (error) {
        console.error(error);

        res.status(500).json({
            message: "Internal server error"
        });
    }
};

module.exports = {
    getServices, createService, getServiceById, updateService, deleteService
};