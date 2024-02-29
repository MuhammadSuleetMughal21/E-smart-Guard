const validator = require("validator");
const routeModel = require("../models/Route");

exports.userSignUpValidation = (req, res, next) => {
  const rolesEnum = ["Guard", "Supervisor", "Admin"];
  req.check("first_name", "First Name is required").notEmpty();
  req.check("last_name", "Last Name is required").notEmpty();
  req.check("email", "Email is required").notEmpty();
  req.check("email", "Invalid email format").custom((value) => {
    return validator.isEmail(value);
  });

  req.check("password", "Password is required").notEmpty();
  req
    .check("password")
    .isLength({ min: 8 })
    .withMessage("Password must contain at least 8 characters")
    .matches(/\d/)
    .withMessage("Password must contain a number");

  req.check("role", "Invalid role").custom((value) => {
    return rolesEnum.includes(value);
  });

  req.check("phone_number", "Phone number is required").notEmpty();
  req.check("phone_number", "Invalid phone number").custom((value) => {
    return (
      validator.isNumeric(value)
    );
  });
  req.check("phone_number", "Phone number must be 11 digits").custom((value) => {
    return (
      validator.isLength(value, { min: 11, max: 11 })
    );
  });

  const errors = req.validationErrors();
  if (errors) {
    const firstError = errors.map((error) => error.msg)[0];
    return res.status(400).json({ error: firstError });
  }

  next();
};

exports.userSignInValidation = (req, res, next) => {
  req.check("email", "Email is required").notEmpty();
  req.check("email", "Invalid email format").custom((value) => {
    return validator.isEmail(value);
  });
  req.check("password", "Password is required").notEmpty();

  const errors = req.validationErrors();

  if (errors) {
    const firstError = errors.map((error) => error.msg)[0];
    return res.status(400).json({ error: firstError });
  }

  next();
};

exports.routeValidation = async (req, res, next) => {
  req.check("name", "Route Name is required").notEmpty();

  const existingRoute = await routeModel.findOne({ name: req.body.name });

  if (existingRoute) {
    return res.status(400).json({ error: "Route Name must be unique" });
  }

  const errors = req.validationErrors();

  if (errors) {
    const firstError = errors.map((error) => error.msg)[0];
    return res.status(400).json({ error: firstError });
  }

  next();
};
