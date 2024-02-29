const mongoose = require("mongoose");
const { ObjectId } = mongoose.Schema;

const notificationSchema = new mongoose.Schema(
  {
    content: {
      type: String,
      required: true,
      trim: true,
    },
    user: {
      type: ObjectId,
      ref: "User",
    },
    from: {
      type: String,
      default: "Supervisor",
      enum: ["Supervisor", "Admin", "Guard"],
    },
    phone_number: {
      type: String,
      trim: true,
    },
    seen: {
      type: String,
      default: "Unread",
      enum: ["Unread", "Read"],
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Notification", notificationSchema);
