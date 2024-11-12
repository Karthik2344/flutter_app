// config/db.js
import mongoose from "mongoose";

export const connectToDatabase = async () => { // Renamed to match import
  mongoose.set("strictQuery", false);
  try {
    await mongoose.connect("mongodb://127.0.0.1:27017/palmpower");
    console.log("Connected to MongoDB");
  } catch (error) {
    console.error("Error connecting to MongoDB:", error);
  }
};
