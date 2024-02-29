const userModel = require("../models/User");
const accessibleRouteModel = require("../models/AccessibleRoute");
const notificationModel = require("../models/Notification");
const routeModel = require("../models/Route");
const nfcTrackerModel = require("../models/NfcTracker");
const activityModel = require("../models/Activity");

exports.findUserById = (req, res, next, id) => {
  userModel
    .findById(id)
    .exec()
    .then((user) => {
      if (!user) {
        return res.status(400).json({
          error: "User not found",
        });
      }
      req.profile = user;
      next();
    })
    .catch((error) => {
      return res.status(400).json({
        error: "User not found",
      });
    });
};

exports.storeUserDeviceToken = async (req, res) => {
  try {
    const { device_token } = req.body;
    const result = await userModel
      .findById(req.profile._id)
      .exec()
      .then((user) => {
        if (!user) {
          res.status(400).json({
            error: "User with that id is not found",
          });
        }
        user.device_token = device_token;
        user.save();
        res.status(200).json({
          message: "Device Token stored successfully.",
          data: user,
        });
      })
      .catch((error) => {
        res.status(400).json({
          error: "User with that id is not found",
        });
      });
  } catch (error) {
    res.status(400).json({
      error: "Internal Server Error",
    });
  }
};

exports.getMyAccessibleRoute = async (req, res) => {
  try {
    const userAccessibleRoutes = await accessibleRouteModel.find({
      user: req.profile._id,
    });
    res.status(200).json({
      data: userAccessibleRoutes,
    });
  } catch (error) {
    res.status(400).json({
      error: "Internal Server Error",
    });
  }
};

exports.getMyNotifications = async (req, res) => {
  try {
    const notifications = await notificationModel
      .find({
        user: req.profile._id,
        from: { $ne: "Guard" },
      })
      .sort({ createdAt: -1 });
    res.status(200).json({
      data: notifications,
    });
  } catch (error) {
    res.status(400).json({
      error: "Internal Server Error",
    });
  }
};

exports.markReadToMyNotication = async (req, res) => {
  try {
    const { notificationId } = req.body;
    const result = await notificationModel
      .findById(notificationId)
      .exec()
      .then((notification) => {
        if (!notification) {
          res.status(400).json({
            error: "Notification with that id is not found",
          });
        }
        notification.seen = "Read";
        notification.save();
        res.status(200).json({
          message: "Notification read successfully.",
        });
      })
      .catch((error) => {
        res.status(400).json({
          error: "Notification with that id is not found",
        });
      });
  } catch (error) {
    res.status(400).json({
      error: "Internal Server Error",
    });
  }
};

exports.getAllRoutes = async (req, res) => {
  try {
    const routes = await routeModel.find().sort({ createdAt: -1 });
    res.status(200).json({
      data: routes,
    });
  } catch (error) {
    res.status(400).json({
      error: "Internal Server Error",
    });
  }
};

exports.getAllNfcTracker = async (req, res) => {
  try {
    const trackers = await nfcTrackerModel
      .find()
      .sort({ createdAt: -1 });
    res.status(200).json({
      data: trackers,
    });
  } catch (error) {
    res.status(400).json({
      error: "Internal Server Error",
    });
  }
};

exports.logout = async (req, res) => {
  try {
    const userActivity = await activityModel.findOne({
      user: req.profile._id,
      activity: "Logout",
    });

    if (userActivity) {
      userActivity.time = new Date();
      await userActivity.save();
    } else {
      if (req.profile.role == "Guard") {
        const activity = new activityModel({
          activity: "Logout",
          user: req.profile._id,
          time: new Date(),
        });
        await activity.save();
      }
    }

    res.json({
      message: "Logout successfully",
    });
  } catch (error) {
    res.status(400).json({
      error: "Internal Server Error",
    });
  }
};

exports.extendOrForgetScanning = async (req, res) => {
  try {
    const { extend } = req.body;
    let content = "";
    if (extend == "extend") {
      content = req.profile.role + " has extended its time";
    } else {
      content = req.profile.role + " has ran out of time";
    }
    const newNotification = new notificationModel({
      user: req.profile._id,
      content: content,
      phone_number: req.profile.phone_number,
      from: req.profile.role,
    });
    await newNotification.save();
    res.status(200).json({
      message: "Notification has been sent.",
    });
  } catch (error) {
    res.status(400).json({
      error: "Internal Server Error",
    });
  }
};

exports.petrollingCompletion = async (req, res) => {
  try {
    const userId = req.profile._id;
    const result = await userModel
      .findById(userId)
      .exec()
      .then((user) => {
        if (!user) {
          res.status(400).json({
            error: "Guard with that id is not found",
          });
        }

        user.petrolling = "Petrolling is completed";
        user.save();
        res.status(200).json({
          message: "Petrolling Completed Successfully",
        });
      })
      .catch((error) => {
        res.status(400).json({
          error: "Guard with that id is not found",
        });
      });
  } catch (error) {
    res.status(400).json({
      error: "Internal Server Error",
    });
  }
};

exports.saveUserLocation = async (req, res) => {
  try {
    const { location } = req.body;
    const result = await userModel
      .findById(req.profile._id)
      .exec()
      .then((user) => {
        if (!user) {
          res.status(400).json({
            error: "User with that id is not found",
          });
        }
        user.location = location;
        user.save();
        res.status(200).json({
          message: "Location stored successfully.",
        });
      })
      .catch((error) => {
        res.status(400).json({
          error: "User with that id is not found",
        });
      });
  } catch (error) {
    res.status(400).json({
      error: "Internal Server Error",
    });
  }
};
