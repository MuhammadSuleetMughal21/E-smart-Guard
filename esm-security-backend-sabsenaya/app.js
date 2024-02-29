const express = require("express");
const morgan = require("morgan");
const bodyParser = require("body-parser");
const expressValidator = require("express-validator");
const cors = require("cors");
const passport = require("passport");
const cookieSession = require("cookie-session");
const expressSession = require("express-session");
require("dotenv").config();

//DATABASE
const databaseConnection = require("./database/DbConnection");
const passportSetup = require("./passport/passport");

//router
const authRouter = require("./routes/AuthRoutes");
const adminRouter = require("./routes/AdminRoutes");
const userRouter = require("./routes/UserRoutes");
const supervisorRouter = require("./routes/SupervisorRoute");
const globalRoutes = require("./routes/GlobalRoutes");

const app = express();
databaseConnection();
const port = process.env.PORT || 8000;

//MIDDLEWARES
app.use(morgan("dev"));
app.use(bodyParser.json());
app.use(expressValidator());
app.use(
  cookieSession({
    name: "session",
    keys: ["esmsecurity"],
    maxAge: 24 * 60 * 60 * 100,
  })
);
app.use(
  expressSession({
    resave: false,
    saveUninitialized: true,
    secret: "SECRET",
  })
);
app.use(passport.initialize());
app.use(passport.session());

const allowedOrigins = ["http://localhost:3000"];
app.use(
  cors({
    origin: function (origin, callback) {
      if (!origin || allowedOrigins.includes(origin)) {
        callback(null, true);
      } else {
        callback(new Error("Not allowed by CORS"));
      }
    },
    methods: "GET,HEAD,PUT,PATCH,POST,DELETE",
    credentials: true,
    optionsSuccessStatus: 204,
  })
);

app.use("/api", authRouter);
app.use("/api", adminRouter);
app.use("/api", userRouter);
app.use("/api", globalRoutes);
app.use("/api", supervisorRouter);

app.listen(port, () => {
  console.log(`NODE IS RUNNING ON PORT ${port}`);
});
