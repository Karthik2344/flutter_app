import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For base64 encoding

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final titleController = TextEditingController();
  final fieldController = TextEditingController();
  List<Map<String, String>> _images = []; // To store selected images data

  // Function to pick multiple images using FilePicker
  Future<void> _pickImages() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true, // Allow multiple files
      );

      if (result != null) {
        List<Map<String, String>> pickedImages = [];

        for (var file in result.files) {
          if (file.bytes != null) {
            String base64Image = base64Encode(file.bytes!);
            pickedImages.add({
              "image": base64Image,
              "imageName": file.name,
            });
          }
        }

        setState(() {
          _images = pickedImages; // Store selected images
        });
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking images: $e'),
        ),
      );
    }
  }

  // Function to save form data
  Future<void> _saveFormData() async {
    final title = titleController.text;
    final fields = fieldController.text;

    if (title.isEmpty || fields.isEmpty || _images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and pick images.'),
        ),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/api/forms'), // Backend API URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'fields': fields,
          'images': _images, // Send the images array to backend
        }),
      );

      if (response.statusCode == 200) {
        titleController.clear();
        fieldController.clear();
        setState(() {
          _images = []; // Clear selected images
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Form saved successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // Handle error response here
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save form: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      // Handle exceptions here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving form: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Form Title'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: fieldController,
            decoration: const InputDecoration(hintText: 'Form Field'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickImages,
            child: const Text('Pick Images'),
          ),
          const SizedBox(height: 10),
          _images.isEmpty
              ? const Text('No images selected.')
              : Wrap(
                  spacing: 10,
                  children:
                      _images.map((img) => const Icon(Icons.image)).toList(),
                ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveFormData,
            child: const Text('Save Form'),
          ),
        ],
      ),
    );
  }
}
