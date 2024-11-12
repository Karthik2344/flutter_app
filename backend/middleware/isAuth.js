// middleware/isAuth.js
import jwt from "jsonwebtoken";
import { User } from "../models/User.js";

export const isAuth = async (req, res, next) => {
  try {
    const token = req.headers.token;

    if (!token) {
      return res.status(403).json({ message: "Please Login" });
    }

    try {
      const decodedData = jwt.verify(token, process.env.JWT_SECRET);
      const user = await User.findById(decodedData._id);
      if (!user) {
        return res.status(404).json({ message: "User not found" });
      }

      req.user = user;
      next();
    } catch (error) {
      if (error.name === "JsonWebTokenError") {
        return res.status(400).json({ message: "Invalid Token" });
      } else if (error.name === "TokenExpiredError") {
        return res.status(401).json({ message: "Token Expired" });
      } else {
        return res.status(500).json({ message: "Token Verification Failed" });
      }
    }
  } catch (error) {
    res.status(500).json({ message: "Login First" });
  }
};
