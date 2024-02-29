const mongoose = require("mongoose");
const { ObjectId } = mongoose.Schema;

const notificationSchema = new mongoose.Schema(
  {
    activity: {
      type: String,
      required: true,
      trim: true,
    },
    user: {
      type: ObjectId,
      ref: "User",
      required: true,
    },
    time: {
      type: Date,
      required: true,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Activity", notificationSchema);
