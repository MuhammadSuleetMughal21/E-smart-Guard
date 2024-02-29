const express = require("express");
const router = express.Router();

const {
  requireSignin,
  isAuth,
  isAdmin,
  signUp,
} = require("../controllers/AuthController");
const { findUserById } = require("../controllers/UserController");
const {
  userSignUpValidation,
  routeValidation,
} = require("../validator/AuthValidation");
const {
  getAllUsersExceptAdmin,
  blockGuardUser,
  addRoute,
  addNfcTracker,
} = require("../controllers/AdminController");

router.get(
  "/get-all-users/:adminId",
  requireSignin,
  isAuth,
  isAdmin,
  getAllUsersExceptAdmin
);
router.post(
  "/block-user/:adminId",
  requireSignin,
  isAuth,
  isAdmin,
  blockGuardUser
);
router.post(
  "/register-guard/:adminId",
  requireSignin,
  isAuth,
  isAdmin,
  userSignUpValidation,
  signUp
);
router.post(
  "/create-route/:adminId",
  requireSignin,
  isAuth,
  isAdmin,
  routeValidation,
  addRoute
);

router.post(
  "/create-nfc/:adminId",
  requireSignin,
  isAuth,
  isAdmin,
  addNfcTracker
);

router.param("adminId", findUserById);

module.exports = router;
