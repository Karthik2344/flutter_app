// import express from 'express';
// import { connect, model, Schema } from 'mongoose';
// import cors from 'cors';
// import bodyParser from 'body-parser';
// import fs from 'fs';
// import path from 'path';
// import { fileURLToPath } from 'url';

// // Use fileURLToPath and path to emulate __dirname
// const __filename = fileURLToPath(import.meta.url);
// const __dirname = path.dirname(__filename);

// // Initialize the app
// const app = express();
// const PORT = process.env.PORT || 5000;

// // Connect to MongoDB
// connect('mongodb://localhost:27017/palmpower', {
//   useNewUrlParser: true,
//   useUnifiedTopology: true,
// })
//   .then(() => console.log('MongoDB connected'))
//   .catch((err) => console.log('MongoDB connection error:', err));

// // Middleware
// app.use(cors());

// // Increase the bodyParser limit for larger payloads
// app.use(bodyParser.json({ limit: '10mb' }));
// app.use(bodyParser.urlencoded({ limit: '10mb', extended: true }));

// // Serve static files from the uploads folder
// app.use('/uploads', express.static('uploads'));

// // Create 'uploads' folder if it doesn't exist
// const uploadsDir = path.join(__dirname, 'uploads');
// if (!fs.existsSync(uploadsDir)) {
//   fs.mkdirSync(uploadsDir);
// }

// // Form Schema
// const formSchema = new Schema({
//   title: { type: String, required: true },
//   fields: { type: String, required: true },
//   image: { type: String, required: true },
//   imageName: { type: String, required: true },
// });

// const Form = model('Form', formSchema);

// // API Endpoint to save form data
// app.post('/api/forms', (req, res) => {
//   const { title, fields, image, imageName } = req.body;

//   // Check for required fields
//   if (!image || !imageName) {
//     return res.status(400).json({ error: 'Image data and name are required' });
//   }

//   // Convert base64 image to buffer
//   const imageBuffer = Buffer.from(image, 'base64');
//   const imagePath = path.join(__dirname, 'uploads', imageName);

//   // Save the image file
//   fs.writeFile(imagePath, imageBuffer, (err) => {
//     if (err) {
//       console.error('Error saving image:', err);
//       return res.status(500).json({ error: 'Failed to save image' });
//     }

//     // Create a new form entry in the database
//     const newForm = new Form({
//       title,
//       fields,
//       image: `/uploads/${imageName}`,
//       imageName,
//     });

//     newForm
//       .save()
//       .then((result) => res.status(200).json(result))
//       .catch((err) => {
//         console.error('Error saving form to DB:', err);
//         res.status(500).json({ error: 'Failed to save form in the database' });
//       });
//   });
// });

// // Start the server
// app.listen(PORT, () => {
//   console.log(`Server running on port ${PORT}`);
// });

// server.js
import express from "express";
import cors from "cors";
import bodyParser from "body-parser";
import { connectToDatabase } from "./config/db.js"; // Ensure you have this function set up
import formRoutes from "./routes/formRoutes.js";
import userRoutes from "./routes/userRoutes.js";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";
import dotenv from "dotenv";
// Use fileURLToPath and path to emulate __dirname
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Create 'uploads' folder if it doesn't exist
const uploadsDir = path.join(__dirname, "uploads");
if (!fs.existsSync(uploadsDir)) {
  fs.mkdirSync(uploadsDir);
}

// Initialize the app
const app = express();
const PORT = process.env.PORT || 5000;
dotenv.config();

// Connect to MongoDB
connectToDatabase();

// Middleware
app.use(cors());
app.use(bodyParser.json({ limit: "10mb" }));
app.use(bodyParser.urlencoded({ limit: "10mb", extended: true }));

// Serve static files from the uploads folder
app.use("/uploads", express.static("uploads"));

// Routes
app.use("/api/users", userRoutes);
app.use("/api/forms", formRoutes); // Ensure form routes are also correctly defined

// Start the server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
