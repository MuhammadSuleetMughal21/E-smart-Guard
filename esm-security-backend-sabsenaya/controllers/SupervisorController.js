const userModel = require("../models/User");
const accessibleRouteModel = require("../models/AccessibleRoute");
const notificationModel = require("../models/Notification");
const routeModel = require("../models/Route");
const nfcTrackerModel = require("../models/NfcTracker");
const activityModel = require("../models/Activity");

exports.manageGuardRoute = async (req, res) => {
  try {
    const { userId, routeName, nfcTracker, loop } = req.body;

    const validRoute = await routeModel.findOne({ name: routeName });

    if (!validRoute) {
      return res.status(400).json({
        error: "Specified route does not exist.",
      });
    }

    const user = await userModel
      .findById(userId)
      .exec()
      .then(async (user) => {
        if (!user) {
          return res.status(400).json({
            error: "Guard with that id is not found",
          });
        }

        const route = await accessibleRouteModel.findOne({
          user: userId,
        });

        for (let index = 0; index < nfcTracker.length; index++) {
          // res.json(nfcTracker[index]);
          const nfc = await nfcTrackerModel.findOne({
            name: nfcTracker[index],
          });
          if (nfc) {
            await nfcTrackerModel.updateOne(
              { _id: nfc._id },
              { $set: { isShow: 0 } }
            );
          }
        }
        if (route) {
          await route.deleteOne();
        }
        const newRoute = new accessibleRouteModel({
          user: userId,
          route_name: routeName,
          nfc_trackers: nfcTracker,
          loop: loop,
        });
        await newRoute.save();
        res.status(200).json({
          message: "Access has been granted to guard.",
        });
      })
      .catch((error) => {
        return res.status(400).json({
          error: "Guard with that id is not found",
        });
      });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      error: "Internal Server Error",
    });
  }
};

exports.getAllGuardUsers = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;

    const totalUsers = await userModel.countDocuments({
      role: { $nin: ["Admin", "Supervisor"] },
      is_blocked: { $ne: 1 },
    });

    const totalPages = Math.ceil(totalUsers / limit);

    const users = await userModel
      .find({ role: { $nin: ["Admin", "Supervisor"] }, is_blocked: { $ne: 1 } })
      .select("-salt -hashed_password")
      .skip((page - 1) * limit)
      .limit(limit);

    const populatedUsers = await Promise.all(
      users.map(async (user) => {
        const userRoutes = await accessibleRouteModel
          .find({ user: user._id })
          .select("route_name nfc_trackers loop");
        return { ...user.toObject(), accessibleRoutes: userRoutes };
      })
    );

    const transformedUsers = populatedUsers.map((user) => {
      const { accessibleRoutes, ...rest } = user;
      const routesByKey = accessibleRoutes.reduce((acc, route) => {
        acc[route.route_name] = {
          nfc_trackers: route.nfc_trackers,
          loop: route.loop,
        };
        return acc;
      }, {});
      return {
        ...rest,
        accessibleRoutes: routesByKey,
      };
    });

    res.status(200).json({
      data: transformedUsers,
      currentPage: page,
      totalPages: totalPages,
      pageSize: limit,
    });
  } catch (error) {
    res.status(500).json({
      error: error,
    });
  }
};

exports.getMyLocation = async (req, res) => {
  try {
    const { userId } = req.body;
    const content = req.profile.role + " wants to access your location.";

    await userModel
      .findById(userId)
      .exec()
      .then(async (user) => {
        if (!user) {
          return res.status(400).json({
            error: "Guard with that id is not found",
          });
        }
        const newNotification = new notificationModel({
          user: userId,
          content: content,
          phone_number: req.profile.phone_number,
          from: req.profile.role,
        });
        await newNotification.save();
        res.status(200).json({
          message: "Notification for location has been sent to user.",
        });
      })
      .catch((error) => {
        return res.status(400).json({
          error: "Guard with that id is not found",
        });
      });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      error: "Internal Server Error",
    });
  }
};

exports.getAllUserActivity = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;

    const totalActivities = await activityModel.countDocuments();

    const totalPages = Math.ceil(totalActivities / limit);

    const activities = await activityModel
      .find()
      .populate("user")
      .skip((page - 1) * limit)
      .limit(limit);

    res.status(200).json({
      data: activities,
      currentPage: page,
      totalPages: totalPages,
      pageSize: limit,
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      error: "Internal Server Error",
    });
  }
};

exports.getNotification = async (req, res) => {
  try {
    const notifications = await notificationModel
      .find({
        from: "Guard",
      })
      .populate("user")
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
