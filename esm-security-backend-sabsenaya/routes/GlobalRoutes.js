const express = require("express");
const router = express.Router();
const {
  getAllRoutes,
  getAllNfcTracker,
} = require("../controllers/UserController");

router.get("/get-all-routes", getAllRoutes);

router.get("/get-all-nfc-tracker", getAllNfcTracker);

module.exports = router;
