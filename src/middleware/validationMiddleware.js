const validateReview = (req, res, next) => {
    const { hospital_id, rating } = req.body;

    if (!hospital_id || isNaN(hospital_id)) {
    return res.status(400).json({
        message: "hospital_id must be a valid number"
    });

    }

    if (!rating) {
        return res.status(400).json({
            message: "rating is required"
        });
    }

    if (rating < 1 || rating > 5) {
        return res.status(400).json({
            message: "rating must be between 1 and 5"
        });
    }

    next();
};

module.exports = validateReview;