const express = require("express");

const {getHospitals,createHospital,getHospitalById,updateHospital, deleteHospital
} = require("../controllers/hospitalController");

const router = express.Router();

router.get("/", getHospitals);

router.post("/", createHospital);

router.get("/:id", getHospitalById);

router.put("/:id", updateHospital);

router.delete("/:id", deleteHospital);
module.exports = router;