const express = require("express");
const router = express.Router();

const { requireSignin, isAuth } = require("../controllers/AuthController");
const {
  findUserById,
  storeUserDeviceToken,
  getMyAccessibleRoute,
  getMyNotifications,
  markReadToMyNotication,
  logout,
  extendOrForgetScanning,
  petrollingCompletion,
  saveUserLocation
} = require("../controllers/UserController");
const { storeDeviceTokenValidation } = require("../validator/UserValidation");

router.post(
  "/store-device-token/:userId",
  requireSignin,
  isAuth,
  storeDeviceTokenValidation,
  storeUserDeviceToken
);

router.get(
  "/get-my-accessible-routes/:userId",
  requireSignin,
  isAuth,
  getMyAccessibleRoute
);

router.get(
  "/get-my-notifications/:userId",
  requireSignin,
  isAuth,
  getMyNotifications
);

router.post(
  "/mark-read-my-notification/:userId",
  requireSignin,
  isAuth,
  markReadToMyNotication
);

router.post("/logout/:userId", requireSignin, isAuth, logout);

router.post(
  "/extend-or-forget-scan/:userId",
  requireSignin,
  isAuth,
  extendOrForgetScanning
);

router.post(
  "/petrolling-complete/:userId",
  requireSignin,
  isAuth,
  petrollingCompletion
);

router.post(
  "/save-user-location/:userId",
  requireSignin,
  isAuth,
  saveUserLocation
);

router.param("userId", findUserById);

module.exports = router;
