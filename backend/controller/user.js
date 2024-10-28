import { User } from "../models/User.js";
import jwt from "jsonwebtoken";

// User Registration Controller
export const register = async (req, res) => {
  const { username, email, password } = req.body; // Include username here
  try {
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ error: "User already exists" });
    }

    const newUser = new User({ username, email, password }); // Add username
    await newUser.save();

    const token = jwt.sign({ id: newUser._id }, "your_secret_key", {
      expiresIn: "1h",
    });

    res.status(201).json({ message: "User registered", token });
  } catch (error) {
    console.error("Error in registration:", error);
    res.status(500).json({ error: "Server error" });
  }
};

// User Login Controller
export const login = async (req, res) => {
  const { email, password } = req.body;
  try {
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ error: "Invalid credentials" });
    }

    const isMatch = await user.comparePassword(password);
    if (!isMatch) {
      return res.status(400).json({ error: "Invalid credentials" });
    }

    const token = jwt.sign({ id: user._id }, "your_secret_key", {
      expiresIn: "1h",
    });

    res.status(200).json({ message: "Login successful", token });
  } catch (error) {
    console.error("Error in login:", error);
    res.status(500).json({ error: "Server error" });
  }
};
