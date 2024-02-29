const mongoose = require("mongoose");
const crypto = require("crypto");
const uuid = require("uuid");

const userSchema = new mongoose.Schema(
  {
    first_name: {
      type: String,
      required: true,
      maxLength: 32,
      trim: true,
    },
    last_name: {
      type: String,
      required: true,
      maxLength: 32,
      trim: true,
    },
    email: {
      type: String,
      required: true,
      unique: 32,
      trim: true,
    },
    hashed_password: {
      type: String,
      required: true,
    },
    device_token: {
      type: String,
      trim: true,
    },
    phone_number: {
      type: String,
      trim: true,
    },
    salt: String,
    role: {
      type: String,
      default: "Guard",
      enum: ["Guard", "Supervisor", "Admin"],
    },
    social_id: {
      type: String,
      trim: true,
    },
    social_type: {
      type: String,
      trim: true,
    },
    is_blocked: {
      type: Number,
      default: 0,
    },
    petrolling: {
      type: String,
      default: "Petrolling is in progress",
    },
    location: {
      type: String,
      trim: true,
    },
  },
  { timestamps: true }
);

//METHODS
// to encrypt the password so it can be secret
userSchema.methods.encryptPassword = function (password) {
  if (!password) {
    return "";
  }
  try {
    return crypto.createHmac("sha1", this.salt).update(password).digest("hex");
  } catch (error) {
    return "";
  }
};

//authenticate to check password is correct when user is logging in
userSchema.methods.authenticate = function (plainText) {
  return this.encryptPassword(plainText) === this.hashed_password;
};

//VIRTUAL FIELDS
userSchema
  .virtual("password")
  .set(function (password) {
    this._password = password;
    this.salt = uuid.v1();
    this.hashed_password = this.encryptPassword(password);
  })
  .get(function () {
    return this._password;
  });

module.exports = mongoose.model("User", userSchema);
