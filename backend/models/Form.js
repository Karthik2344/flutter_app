// models/Form.js
import mongoose from "mongoose";

const formSchema = new mongoose.Schema({
  title: String,
  fields: Object,
  images: [String], // Array to store paths of multiple images
});

export const Form = mongoose.model("Form", formSchema);
