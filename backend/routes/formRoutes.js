// routes/formRoutes.js
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

// Endpoint to save form data
router.post("/", async (req, res) => {
  const { title, fields, image, imageName } = req.body;

  if (!image || !imageName) {
    return res.status(400).json({ error: "Image data and name are required" });
  }

  const imageBuffer = Buffer.from(image, "base64");
  const imagePath = path.join(uploadsDir, imageName);

  fs.writeFile(imagePath, imageBuffer, async (err) => {
    if (err) {
      console.error("Error saving image:", err);
      return res.status(500).json({ error: "Failed to save image" });
    }

    const newForm = new Form({
      title,
      fields,
      image: `/uploads/${imageName}`,
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

// Endpoint to fetch all forms
router.get("/", async (req, res) => {
  try {
    const forms = await Form.find();
    res.status(200).json(forms);
  } catch (error) {
    res.status(500).json({ error: "Failed to retrieve forms" });
  }
});

export default router;
