import { model, Schema } from "mongoose";

const formSchema = new Schema(
  {
    title: { type: String, required: true },
    fields: { type: String, required: true },
    image: { type: String, required: true },
    // imageName: { type: String, required: true },
    // user: { type: Schema.Types.ObjectId, ref: "User" }, // Reference to User
  },
  { timestamps: true }
);

export const Form = model("Form", formSchema);
