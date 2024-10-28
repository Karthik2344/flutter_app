import { model, Schema } from "mongoose";
import bcrypt from "bcryptjs";

// Define the User schema
const userSchema = new Schema(
  {
    username: {
      type: String,
      required: [true, "Username is required"],
      unique: true,
    },
    email: {
      type: String,
      lowercase: true,
      required: [true, "Email can't be empty"],
      match: [
        /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/,
        "Email format is not correct",
      ],
      unique: true,
    },
    password: {
      type: String,
      required: [true, "Password is required"],
    },
    forms: [
      {
        type: Schema.Types.ObjectId,
        ref: "Form", // Reference to Form documents
      },
    ],
  },
  { timestamps: true }
);

// Pre-save middleware to hash password before saving the user
userSchema.pre("save", async function (next) {
  const user = this;

  if (!user.isModified("password")) {
    return next();
  }

  try {
    const salt = await bcrypt.genSalt(10);
    const hash = await bcrypt.hash(user.password, salt);
    user.password = hash;
    next();
  } catch (err) {
    next(err);
  }
});

// Method to compare candidate password with the stored hashed password
userSchema.methods.comparePassword = async function (candidatePassword) {
  return await bcrypt.compare(candidatePassword, this.password);
};

// Export the User model
export const User = model("User", userSchema);
