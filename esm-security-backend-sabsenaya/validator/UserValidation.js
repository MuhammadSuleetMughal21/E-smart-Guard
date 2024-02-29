exports.storeDeviceTokenValidation = (req, res, next) => {
  req.check("device_token", "Device Token is required").notEmpty();
  const errors = req.validationErrors();
  if (errors) {
    const firstError = errors.map((error) => error.msg)[0];
    return res.status(400).json({ error: firstError });
  }
  next();
};
