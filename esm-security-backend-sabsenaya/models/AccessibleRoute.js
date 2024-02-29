const mongoose = require("mongoose");
const { ObjectId } = mongoose.Schema;

const accessibleRouteSchema = new mongoose.Schema(
  {
    route_name: {
      type: String,
      required: true,
      maxLength: 32,
      trim: true,
    },
    nfc_trackers: {
      type: Array,
      required: true,
    },
    loop: {
      type: Number,
      default: 1,
    },
    user: {
      type: ObjectId,
      ref: "User",
      required: true,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("AccessibleRoute", accessibleRouteSchema);
