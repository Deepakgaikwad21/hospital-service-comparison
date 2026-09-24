const pool = require("../config/db");

// GET all hospitals
const getHospitals = async (req, res) => {
    try {
        const { location, name } = req.query;

        let query = "SELECT * FROM hospitals WHERE 1=1";
        const values = [];

        if (location) {
            values.push(location);
            query += ` AND LOWER(location) = LOWER($${values.length})`;
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


// CREATE a new hospital
const createHospital = async (req, res) => {
    try {
        const { name, location } = req.body;
        if (!name || !location) {
    return res.status(400).json({
        message: "name and location are required"
    });
}

        const result = await pool.query(
            `INSERT INTO hospitals (name, location)
             VALUES ($1, $2)
             RETURNING *`,
            [name, location]
        );

        res.status(201).json(result.rows[0]);

    } catch (error) {
        console.error(error);

        res.status(500).json({
            message: "Internal server error"
        });
    }
};


// GET hospital by ID
const getHospitalById = async (req, res) => {
    try {
        const hospitalId = req.params.id;

        const result = await pool.query(
            "SELECT * FROM hospitals WHERE id = $1",
            [hospitalId]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({
                message: "Hospital not found"
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

// UPDATE hospital
const updateHospital = async (req, res) => {
    try {
        const hospitalId = req.params.id;
        const { name, location } = req.body;

        const result = await pool.query(
            `UPDATE hospitals
             SET name = $1, location = $2
             WHERE id = $3
             RETURNING *`,
            [name, location, hospitalId]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({
                message: "Hospital not found"
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

// DELETE hospital
const deleteHospital = async (req, res) => {
    try {
        const hospitalId = req.params.id;

        const result = await pool.query(
            "DELETE FROM hospitals WHERE id = $1 RETURNING *",
            [hospitalId]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({
                message: "Hospital not found"
            });
        }

        res.json({
            message: "Hospital deleted successfully",
            hospital: result.rows[0]
        });

    } catch (error) {
        console.error(error);

        res.status(500).json({
            message: "Internal server error"
        });
    }
};
module.exports = { getHospitals,  createHospital,  getHospitalById,updateHospital, deleteHospital
};