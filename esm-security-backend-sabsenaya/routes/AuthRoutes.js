const express = require("express");
const router = express.Router();

const {
  signUp,
  signIn,
  signOut,
  redirectToGoogleAuthentication,
  redirectCallbackFromGoogleAuthentication,
  successFromGoogleCallback,
  failureFromGoogleCallback,
} = require("../controllers/AuthController");
const {
  userSignUpValidation,
  userSignInValidation,
} = require("../validator/AuthValidation");

router.post("/signup", userSignUpValidation, signUp);
router.post("/signin", userSignInValidation, signIn);
router.get("/signout", signOut);

//social login
router.get("/auth/google/failed", failureFromGoogleCallback);
router.get("/auth/google/success", successFromGoogleCallback);
router.get("/auth/google/callback", redirectCallbackFromGoogleAuthentication);
router.get("/auth/google/redirect", redirectToGoogleAuthentication);

module.exports = router;
