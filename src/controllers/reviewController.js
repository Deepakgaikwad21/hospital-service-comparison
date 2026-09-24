const pool = require("../config/db");

const createReview = async (req, res) => {
    try {
        const { hospital_id, rating, comment } = req.body;

        const result = await pool.query(
            `INSERT INTO reviews (user_id, hospital_id, rating, comment)
             VALUES ($1, $2, $3, $4)
             RETURNING id, user_id, hospital_id, rating, comment, created_at`,
            [req.user.id, hospital_id, rating, comment]
        );

        res.status(201).json(result.rows[0]);

    } catch (error) {
        console.error(error);

        res.status(500).json({
            message: "Internal server error"
        });
    }
};

// get hospitals by reviews
const getHospitalReviews = async (req, res) => {
    try {
        const hospitalId = req.params.hospitalId;

        const result = await pool.query(
            `SELECT
                reviews.id,
                users.name AS user,
                reviews.rating,
                reviews.comment,
                reviews.created_at
             FROM reviews
             JOIN users
                ON reviews.user_id = users.id
             WHERE reviews.hospital_id = $1
             ORDER BY reviews.created_at DESC`,
            [hospitalId]
        );

        res.json(result.rows);

    } catch (error) {
        console.error(error);

        res.status(500).json({
            message: "Internal server error"
        });
    }
};

//get hospital rating
const getHospitalRating = async (req, res) => {
    try {
        const hospitalId = req.params.hospitalId;

        const result = await pool.query(
            `SELECT
                hospital_id,
                ROUND(AVG(rating), 2) AS average_rating,
                COUNT(*) AS total_reviews
             FROM reviews
             WHERE hospital_id = $1
             GROUP BY hospital_id`,
            [hospitalId]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({
                message: "No reviews found"
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
// Update review
const updateReview = async (req, res) => {
    try {
        const reviewId = req.params.id;
        const { rating, comment } = req.body;

        const result = await pool.query(
            `UPDATE reviews
             SET rating = $1,
                 comment = $2
             WHERE id = $3
             AND user_id = $4
             RETURNING id, user_id, hospital_id, rating, comment, created_at`,
            [rating, comment, reviewId, req.user.id]
        );

        if (result.rows.length === 0) {
            return res.status(403).json({
                message: "You can only update your own review"
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

//delete Review
const deleteReview = async (req, res) => {
    try {
        const reviewId = req.params.id;

        const result = await pool.query(
            `DELETE FROM reviews
             WHERE id = $1
             AND user_id = $2
             RETURNING id`,
            [reviewId, req.user.id]
        );

        if (result.rows.length === 0) {
            return res.status(403).json({
                message: "You can only delete your own review"
            });
        }

        res.json({
            message: "Review deleted successfully"
        });

    } catch (error) {
        console.error(error);
        res.status(500).json({
            message: "Internal server error"
        });
    }
};

module.exports = {
    createReview, getHospitalReviews, getHospitalRating, updateReview, deleteReview
};