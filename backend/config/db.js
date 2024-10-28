import mongoose from "mongoose";

export const connectToDatabase = () => {
  mongoose
    .connect("mongodb://localhost:27017/palmpower", {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    })
    .then(() => console.log("MongoDB connected"))
    .catch((err) => console.log("MongoDB connection error:", err));
};
