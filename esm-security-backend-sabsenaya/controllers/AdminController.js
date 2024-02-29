const userModel = require("../models/User");
const routeModel = require("../models/Route");
const nfcTrackerModel = require("../models/NfcTracker");

//FIND THE USER BY ID
exports.getAllUsersExceptAdmin = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;

    const totalUsers = await userModel.countDocuments({
      role: { $ne: "Admin" },
    });

    const totalPages = Math.ceil(totalUsers / limit);

    const users = await userModel
      .find({ role: { $ne: "Admin" } })
      .select("-salt -hashed_password")
      .skip((page - 1) * limit)
      .limit(limit);

    res.status(200).json({
      data: users,
      currentPage: page,
      totalPages: totalPages,
      pageSize: limit,
    });
  } catch (error) {
    res.status(400).json({
      error: "Internal Server Error",
    });
  }
};

exports.blockGuardUser = async (req, res) => {
  try {
    const { userId } = req.body;

    const result = await userModel
      .findById(userId)
      .exec()
      .then((user) => {
        if (!user) {
          res.status(400).json({
            error: "Guard with that id is not found",
          });
        }

        if (user.is_blocked === 0) {
          user.is_blocked = 1;
          user.save();
          res.status(200).json({
            message: "Guard is now blocked",
          });
        } else {
          res.status(200).json({
            message: "Guard is already blocked",
          });
        }
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

exports.addRoute = async (req, res) => {
  try {
    const { name } = req.body;

    const newRoute = new routeModel({
      name: name,
    });

    await newRoute.save();

    res.status(200).json({
      message: "Route Created Successfully.",
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      error: "Internal Server Error",
    });
  }
};

exports.addNfcTracker = async (req, res) => {
  try {
    const { name } = req.body;

    const nfcTracker = new nfcTrackerModel({
      name: name,
    });

    await nfcTracker.save();

    res.status(200).json({
      message: "Tracker Created Successfully.",
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      error: "Internal Server Error",
    });
  }
};
