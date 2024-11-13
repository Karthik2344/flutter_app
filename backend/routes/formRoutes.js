import express from "express";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";
import { Form } from "../models/Form.js";

const router = express.Router();

// Set up directory
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const uploadsDir = path.join(__dirname, "../uploads");
if (!fs.existsSync(uploadsDir)) fs.mkdirSync(uploadsDir);

// Endpoint to save form data with multiple images
router.post("/", async (req, res) => {
  const { title, fields, images } = req.body; // Expecting an array of images

  if (!images || images.length === 0) {
    return res.status(400).json({ error: "At least one image is required" });
  }

  const imagePaths = [];

  for (const imageData of images) {
    const { image, imageName } = imageData;

    if (!image || !imageName) {
      return res.status(400).json({ error: "Each image requires data and a name" });
    }

    const imageBuffer = Buffer.from(image, "base64");
    const imagePath = path.join(uploadsDir, imageName);

    try {
      fs.writeFileSync(imagePath, imageBuffer);
      imagePaths.push(`/uploads/${imageName}`);
    } catch (err) {
      console.error("Error saving image:", err);
      return res.status(500).json({ error: "Failed to save images" });
    }
  }

  // Save form data in the database with image paths
  const newForm = new Form({
    title,
    fields,
    images: imagePaths, // Save all image paths
  });

  try {
    const result = await newForm.save();
    res.status(200).json(result);
  } catch (err) {
    console.error("Error saving form to DB:", err);
    res.status(500).json({ error: "Failed to save form in the database" });
  }
});

// Endpoint to fetch all forms (with all images)
router.get("/", async (req, res) => {
  try {
    const forms = await Form.find();
    res.status(200).json(forms);
  } catch (error) {
    res.status(500).json({ error: "Failed to retrieve forms" });
  }
});

export default router;
