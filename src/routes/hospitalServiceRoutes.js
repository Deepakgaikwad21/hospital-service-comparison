const express = require("express");

const {
    createHospitalService, getHospitalServices, deleteHospitalService, getServicesByHospital, getHospitalsByService, updateHospitalService
} = require("../controllers/hospitalServiceController");

const router = express.Router();

router.post("/", createHospitalService);
router.put("/:id", updateHospitalService);
router.delete("/:id", deleteHospitalService);
router.get("/", getHospitalServices);
router.get("/hospital/:hospitalId", getServicesByHospital);
router.get("/service/:serviceId", getHospitalsByService);
module.exports = router;