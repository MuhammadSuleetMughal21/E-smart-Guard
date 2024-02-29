const mongoose = require("mongoose");

const routeSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      maxLength: 32,
      trim: true,
      unique: 32,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Route", routeSchema);
