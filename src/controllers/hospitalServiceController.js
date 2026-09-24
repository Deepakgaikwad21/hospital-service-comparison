const pool = require("../config/db");

// CREATE hospital-service relationship
const createHospitalService = async (req, res) => {
    try {
        const { hospital_id, service_id, price } = req.body;
        if (price === undefined || price < 0) {
    return res.status(400).json({
        message: "price must be 0 or greater"
    });
}

        const result = await pool.query(
            `INSERT INTO hospital_services
             (hospital_id, service_id, price)
             VALUES ($1, $2, $3)
             RETURNING *`,
            [hospital_id, service_id, price]
        );

        res.status(201).json(result.rows[0]);

    } catch (error) {
        console.error(error);

        if (error.code === "23505") {
            return res.status(409).json({
                message: "This service is already added to this hospital"
            });
        }
        if (error.code === "23503") {
    return res.status(404).json({
        message: "Hospital or service not found"
    });
}

        res.status(500).json({
            message: "Internal server error"
        });
    }
};
// updateHospitalservice
const updateHospitalService = async (req, res) => {
    try {
        const serviceId = req.params.id;
        const { price } = req.body;

        if (price === undefined || price < 0) {
            return res.status(400).json({
                message: "price must be a valid positive number"
            });
        }

        const result = await pool.query(
            `UPDATE hospital_services
             SET price = $1
             WHERE id = $2
             RETURNING *`,
            [price, serviceId]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({
                message: "Hospital service not found"
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

//deleteHospitalService
const deleteHospitalService = async (req, res) => {
    try {
        const serviceId = req.params.id;

        const result = await pool.query(
            `DELETE FROM hospital_services
             WHERE id = $1
             RETURNING *`,
            [serviceId]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({
                message: "Hospital service not found"
            });
        }

        res.json({
            message: "Hospital service deleted successfully",
            hospitalService: result.rows[0]
        });

    } catch (error) {
        console.error(error);

        res.status(500).json({
            message: "Internal server error"
        });
    }
};

// get detailed hospital service data
const getHospitalServices = async (req, res) => {
    try {
        const result = await pool.query(`
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
            ORDER BY hospital_services.id
        `);

        res.json(result.rows);

    } catch (error) {
        console.error(error);

        res.status(500).json({
            message: "Internal server error"
        });
    }
};

// get service by hospital
const getServicesByHospital = async (req, res) => {
    try {
        const hospitalId = req.params.hospitalId;

        const result = await pool.query(`
            SELECT
                hospitals.name AS hospital,
                services.name AS service,
                hospital_services.price
            FROM hospital_services
            JOIN hospitals
                ON hospital_services.hospital_id = hospitals.id
            JOIN services
                ON hospital_services.service_id = services.id
            WHERE hospitals.id = $1
            ORDER BY services.name
        `, [hospitalId]);

        res.json(result.rows);

    } catch (error) {
        console.error(error);

        res.status(500).json({
            message: "Internal server error"
        });
    }
};
// get hospital by service
const getHospitalsByService = async (req, res) => {
    try {
        const serviceId = req.params.serviceId;

        const result = await pool.query(`
            SELECT
                hospitals.name AS hospital,
                services.name AS service,
                hospital_services.price
            FROM hospital_services
            JOIN hospitals
                ON hospital_services.hospital_id = hospitals.id
            JOIN services
                ON hospital_services.service_id = services.id
            WHERE services.id = $1
            ORDER BY hospital_services.price ASC
        `, [serviceId]);

        res.json(result.rows);

    } catch (error) {
        console.error(error);

        res.status(500).json({
            message: "Internal server error"
        });
    }
};
module.exports = {
    createHospitalService, updateHospitalService, deleteHospitalService ,getHospitalServices, getServicesByHospital, getHospitalsByService
};