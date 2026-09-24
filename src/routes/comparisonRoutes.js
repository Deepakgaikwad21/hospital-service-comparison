const express = require("express");

const { compareServices, getCheapestService } = require("../controllers/comparisonController");

const router = express.Router();

router.get("/:service/cheapest", getCheapestService);
router.get("/:service", compareServices);

module.exports = router;