// models/formModel.js
import { model, Schema } from "mongoose";

const formSchema = new Schema(
  {
    title: { type: String, required: true },
    fields: { type: String, required: true },
    image: { type: String, required: true }, // Path to image file
  },
  { timestamps: true }
);

export const Form = model("Form", formSchema);
