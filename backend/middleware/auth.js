import jwt from "jsonwebtoken";

// Middleware to authenticate user by verifying JWT token
export const authMiddleware = (req, res, next) => {
  const token = req.header("Authorization")?.split(" ")[1]; // Token is usually in the form "Bearer token"

  if (!token) {
    return res.status(401).json({ error: "No token, authorization denied" });
  }

  try {
    const decoded = jwt.verify(token, "your_secret_key");
    req.user = decoded; // Store user info in request object
    next();
  } catch (error) {
    res.status(401).json({ error: "Token is not valid" });
  }
};
