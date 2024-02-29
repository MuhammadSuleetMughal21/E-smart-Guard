const mongoose = require("mongoose");
require("dotenv").config();

const databaseConnection = () => {
  mongoose.connect(process.env.DATABASE_URI);

  const db = mongoose.connection;

  db.on("error", (err) => {
    console.error("MongoDB connection error:", err);
  });

  db.once("open", () => {
    console.log("Connected to MongoDB");
  });
};

module.exports = databaseConnection;
