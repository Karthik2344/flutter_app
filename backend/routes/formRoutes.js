// import express from "express";
// import fs from "fs/promises"; // Use promises-based fs for async/await
// import path from "path";
// import { fileURLToPath } from "url"; // Required for ES modules
// import { Form } from "../models/Form.js"; // Import the Form model

// const router = express.Router();

// // Use fileURLToPath and path to emulate __dirname
// const __filename = fileURLToPath(import.meta.url);
// const __dirname = path.dirname(__filename);

// // API Endpoint to save form data
// router.post("/", async (req, res) => {
//   try {
//     const { title, fields, image, imageName } = req.body;

//     // Check for required fields
//     if (!image || !imageName) {
//       console.error("Missing image or imageName");
//       return res
//         .status(400)
//         .json({ error: "Image data and name are required" });
//     }

//     // Convert base64 image to buffer
//     const imageBuffer = Buffer.from(image, "base64");
//     const imagePath = path.join(__dirname, "../uploads", imageName);

//     // Ensure uploads directory exists
//     const uploadsDir = path.join(__dirname, "../uploads");
//     try {
//       await fs.access(uploadsDir); // Check if the directory exists
//     } catch {
//       await fs.mkdir(uploadsDir); // Create the directory if it doesn't exist
//     }

//     // Save the image file asynchronously
//     await fs.writeFile(imagePath, imageBuffer);
//     console.log(`Image saved successfully at ${imagePath}`);

//     // Create a new form entry in the database
//     const newForm = new Form({
//       title,
//       fields,
//       image: `/uploads/${imageName}`, // Store relative path to the image
//       imageName,
//     });

//     const savedForm = await newForm.save();
//     console.log("Form saved successfully:", savedForm);
//     return res.status(200).json(savedForm);
//   } catch (error) {
//     console.error("Error:", error);
//     return res
//       .status(500)
//       .json({ error: "An error occurred", details: error.message });
//   }
// });

// export default router;

import express from "express";
import { Form } from "../models/Form.js"; // Import your Form model
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const router = express.Router();

// Use fileURLToPath and path to emulate __dirname
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// API Endpoint to save form data
router.post("/", async (req, res) => {
  const { title, fields, image, imageName, userId } = req.body; // Expecting userId to associate form with user

  if (!image || !imageName) {
    return res.status(400).json({ error: "Image data and name are required" });
  }

  const imageBuffer = Buffer.from(image, "base64");
  const imagePath = path.join(__dirname, "../uploads", imageName);

  fs.writeFile(imagePath, imageBuffer, async (err) => {
    if (err) {
      console.error("Error saving image:", err);
      return res.status(500).json({ error: "Failed to save image" });
    }

    const newForm = new Form({
      title,
      fields,
      image: `/uploads/${imageName}`,
      imageName,
      user: userId, // Associate form with user
    });

    try {
      const result = await newForm.save();
      res.status(200).json(result);
    } catch (err) {
      console.error("Error saving form to DB:", err);
      res.status(500).json({ error: "Failed to save form in the database" });
    }
  });
});

export default router;
