const express = require("express");

const { getServices, createService, getServiceById, updateService, deleteService

} = require("../controllers/serviceController");

const router = express.Router();

router.get("/", getServices);

router.post("/", createService);

router.get("/:id", getServiceById);

router.put("/:id", updateService);

router.delete("/:id", deleteService);
module.exports = router;