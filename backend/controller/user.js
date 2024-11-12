// controllers/userController.js
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { User } from "../models/User.js";
import TryCatch from "../middleware/TryCatch.js";

// Register function
export const register = TryCatch(async (req, res) => {
  const { email, name, password } = req.body;

  const existingUser = await User.findOne({ email: email });
  if (existingUser) {
    return res
      .status(400)
      .json({ message: "Email Id is already registered", alert: false });
  }

  const hashPassword = await bcrypt.hash(password, 10);
  const user = new User({
    name,
    email,
    password: hashPassword,
  });
  await user.save();

  res.status(201).json({ message: "Successfully signed up", alert: true });
});

// Login function
export const login = TryCatch(async (req, res) => {
  const { email, password } = req.body;
  const user = await User.findOne({ email: email });

  if (user) {
    const isMatch = await bcrypt.compare(password, user.password);
    if (isMatch) {
      const token = jwt.sign({ _id: user._id }, process.env.JWT_SECRET, {
        expiresIn: "1h",
      });

      res.status(200).json({
        message: "Login is Successful",
        alert: true,
        data: {
          _id: user._id,
          name: user.name,
          email: user.email,
          token: token,
        },
      });
    } else {
      res.status(400).json({ message: "Incorrect password", alert: false });
    }
  } else {
    res.status(404).json({
      message: "Email is not registered, please sign up",
      alert: false,
    });
  }
});
