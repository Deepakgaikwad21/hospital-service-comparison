const express = require("express");

const authMiddleware = require("../middleware/authMiddleware");

const router = express.Router();

router.get("/test", (req, res) => {
    res.json({
        message: "Profile route is working"
    });
});
// Normal authenticated profile
router.get("/", authMiddleware, (req, res) => {
    res.json({
        message: "You are authenticated",
        user: req.user
    });
});

// Admin-only profile
router.get("/admin", authMiddleware, (req, res) => {

    if (req.user.role !== "admin") {
        return res.status(403).json({
            message: "Access denied"
        });
    }

    res.json({
        message: "Welcome Admin",
        user: req.user
    });
});

module.exports = router;