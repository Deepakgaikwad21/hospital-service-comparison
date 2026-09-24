const express = require("express");

const {
    createReview, getHospitalReviews, getHospitalRating, updateReview, deleteReview
} = require("../controllers/reviewController");

const authMiddleware = require("../middleware/authMiddleware");
const validateReview = require("../middleware/validationMiddleware");

const router = express.Router();

router.post("/", authMiddleware, validateReview,createReview);
router.put("/:id", authMiddleware,validateReview, updateReview);
router.delete("/:id", authMiddleware, deleteReview);


router.get("/hospital/:hospitalId/rating", getHospitalRating);

router.get("/hospital/:hospitalId", getHospitalReviews);

module.exports = router;