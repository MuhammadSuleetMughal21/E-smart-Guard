const userModel = require("../models/User");
const activityModel = require("../models/Activity");
const { errorHandler } = require("../helpers/index"); //for email uniquness
const jwtToken = require("jsonwebtoken"); //to generate token when user signed in
var { expressjwt: jwt } = require("express-jwt"); //to authorisation check
const passport = require("passport");

exports.signUp = async (req, res) => {
  try {
    const { email, role } = req.body;
    const existingUser = await userModel.findOne({ email });
    if (existingUser) {
      return res
        .status(400)
        .json({ message: "User already exists with that email." });
    }

    if (role === "Admin") {
      const existingAdmin = await userModel.findOne({ role: "Admin" });
      if (existingAdmin) {
        return res.status(400).json({ message: "Admin user already exists." });
      }
    }

    if (role === "Supervisor") {
      const existingAdmin = await userModel.findOne({ role: "Supervisor" });
      if (existingAdmin) {
        return res
          .status(400)
          .json({ message: "Supervisor user already exists." });
      }
    }
    //admin will register the guard
    if (
      req.profile &&
      req.auth &&
      req.profile.role === "Admin" &&
      role === "Guard"
    ) {
      const guardUser = new userModel(req.body);
      guardUser
        .save(req.body)
        .then((data) => {
          data.salt = undefined;
          data.hashed_password = undefined;
          res.json({
            message: "Guard Registered Successfully.",
            data,
          });
        })
        .catch((error) => {
          console.log(error);
          res.status(400).json({
            error: errorHandler(error),
          });
        });
    } else {
      if (role !== "Guard") {
        const user = new userModel(req.body);
        user
          .save(req.body)
          .then((data) => {
            data.salt = undefined;
            data.hashed_password = undefined;
            res.json({
              message: "User Registered Successfully.",
              data,
            });
          })
          .catch((error) => {
            console.log(error);
            res.status(400).json({
              error: errorHandler(error),
            });
          });
      } else {
        res.status(400).json({
          error: "Guard cannot registered directly.",
        });
      }
    }
  } catch (error) {
    console.log(error);
    res.status(400).json({
      error: error,
    });
  }
};

exports.signIn = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await userModel.findOne({ email });

    if (!user) {
      return res.status(400).json({
        error: "User with that email does not exist. Please Signup.",
      });
    }

    if (!user.authenticate(password)) {
      return res.status(401).json({
        error: "Password does not match",
      });
    }

    const { _id, first_name, last_name, role, is_blocked } = user;

    if (is_blocked == 1) {
      return res.status(401).json({
        error: "User has been blocked by admin.",
      });
    }

    const userActivity = await activityModel.findOne({
      user: _id,
      activity: "Login",
    });

    if (userActivity) {
      userActivity.time = new Date();
      await userActivity.save();
    } else {
      if (role == "Guard") {
        const activity = new activityModel({
          activity: "Login",
          user: _id,
          time: new Date(),
        });
        await activity.save();
      }
    }
    const token = jwtToken.sign({ _id: user._id }, process.env.JWT_SECRET);
    res.cookie("token", token, { expiry: new Date() + 9999 });

    res.json({
      token,
      user: { _id, first_name, last_name, email, role },
    });
  } catch (error) {
    console.log(error);
    res.status(400).json({
      error: "An error occurred during sign-in.",
    });
  }
};

exports.signOut = (req, res) => {
  res.clearCookie("token");
  res.json({
    message: "Sign Out successfully.",
  });
};

exports.redirectToGoogleAuthentication = passport.authenticate("google", {
  scope: ["profile", "email"],
});

exports.redirectCallbackFromGoogleAuthentication = passport.authenticate(
  "google",
  {
    successRedirect: "/api/auth/google/success",
    failureRedirect: "/api/auth/google/failed",
  }
);

exports.successFromGoogleCallback = async (req, res) => {
  try {
    if (req.user) {
      const existingUser = await userModel.findOne({ social_id: req.user.id });
      if (existingUser) {
        const { _id, first_name, last_name, role, is_blocked, email } =
          existingUser;
        if (is_blocked == 1) {
          return res.status(403).json({
            error: "User has been blocked by admin.",
          });
        } else {
          const token = jwtToken.sign(
            { _id: existingUser._id },
            process.env.JWT_SECRET
          );
          res.cookie("token", token, { expiry: new Date() + 9999 });

          res.json({
            token,
            user: { _id, first_name, last_name, email, role },
          });
        }
      } else {
        const newUser = await userModel.create({
          first_name: req.user._json.given_name,
          last_name: req.user._json.family_name,
          email: req.user._json.email,
          hashed_password: "Google123",
          role: "Guard",
          social_type: "google",
          social_id: req.user.id,
        });
        const { _id, first_name, last_name, role, email } = newUser;

        const token = jwtToken.sign(
          { _id: newUser._id },
          process.env.JWT_SECRET
        );
        res.cookie("token", token, { expiry: new Date() + 9999 });

        res.json({
          token,
          user: { _id, first_name, last_name, email, role },
        });
      }
    } else {
      res.status(403).json({
        error: "Not Authorized",
      });
    }
  } catch (error) {
    console.log(error);
    res.status(500).json({
      error: "An error occurred while processing the Google login." + error,
    });
  }
};

exports.failureFromGoogleCallback = (req, res) => {
  res.status(401).json({
    error: "An error occured while logging through google.",
  });
};

exports.requireSignin = jwt({
  secret: process.env.JWT_SECRET,
  algorithms: ["HS256"],
  userProperty: "auth",
});

exports.isAuth = (req, res, next) => {
  let user = req.profile && req.auth && req.profile._id == req.auth._id;
  if (!user) {
    return res.status(403).json({
      error: "Access Denied!",
    });
  }
  next();
};

exports.isGuard = (req, res, next) => {
  if (req.profile.role === "Guard") {
    next();
  } else {
    return res.status(403).json({
      error: " Access Denied! Only Guard Has Rights to Access this Resource.",
    });
  }
};

exports.isSupervisor = (req, res, next) => {
  if (req.profile.role === "Supervisor") {
    next();
  } else {
    return res.status(403).json({
      error:
        " Access Denied! Only Supervisor Has Rights to Access this Resource.",
    });
  }
};

exports.isAdmin = (req, res, next) => {
  if (req.profile.role === "Admin") {
    next();
  } else {
    return res.status(403).json({
      error: " Access Denied! Only Admin Has Rights to Access this Resource.",
    });
  }
};

exports.isSupervisorOrAdmin = (req, res, next) => {
  const allowedRoles = ["Supervisor", "Admin"];
  if (allowedRoles.includes(req.profile.role)) {
    next();
  } else {
    return res.status(403).json({
      error:
        "Access Denied! Only Supervisor and Admin have rights to access this resource.",
    });
  }
};
