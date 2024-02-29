const express = require("express");
const router = express.Router();

const {
  requireSignin,
  isAuth,
  isSupervisor,
  isSupervisorOrAdmin,
} = require("../controllers/AuthController");
const { findUserById } = require("../controllers/UserController");
const {
  manageGuardRoute,
  getAllGuardUsers,
  getMyLocation,
  getAllUserActivity,
  getNotification
} = require("../controllers/SupervisorController");

router.post(
  "/manage-guard-route/:supervisorId",
  requireSignin,
  isAuth,
  isSupervisor,
  manageGuardRoute
);

router.get(
  "/get-all-guard-users/:supervisorId",
  requireSignin,
  isAuth,
  isSupervisorOrAdmin,
  getAllGuardUsers
);

router.post(
  "/get-my-location/:supervisorId",
  requireSignin,
  isAuth,
  isSupervisorOrAdmin,
  getMyLocation
);

router.get(
  "/get-user-activity/:supervisorId",
  requireSignin,
  isAuth,
  isSupervisorOrAdmin,
  getAllUserActivity
);

router.get(
  "/get-notifcations/:supervisorId",
  requireSignin,
  isAuth,
  isSupervisorOrAdmin,
  getNotification
);

router.param("supervisorId", findUserById);

module.exports = router;
