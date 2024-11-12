import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For base64 encoding
import 'dart:typed_data';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final titleController = TextEditingController();
  final fieldController = TextEditingController();
  Uint8List? _imageBytes; // To store the picked image bytes
  String? _imageName; // To store the image name
  String? _base64Image; // To store the Base64 encoded image

  // Function to pick an image using FilePicker
  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _imageBytes = result.files.single.bytes;
          _imageName = result.files.single.name;
          _base64Image = base64Encode(_imageBytes!);
        });
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
        ),
      );
    }
  }

  // Function to save form data
  Future<void> _saveFormData() async {
    final title = titleController.text;
    final fields = fieldController.text;

    if (title.isEmpty || fields.isEmpty || _base64Image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and pick an image.'),
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
          'image': _base64Image, // Send the image as base64
          'imageName': _imageName // Send the image name
        }),
      );

      if (response.statusCode == 200) {
        titleController.clear();
        fieldController.clear();
        setState(() {
          _imageBytes = null;
          _imageName = null;
          _base64Image = null;
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
            onPressed: _pickImage,
            child: const Text('Pick Image'),
          ),
          const SizedBox(height: 10),
          _imageBytes == null
              ? const Text('No image selected.')
              : Image.memory(_imageBytes!, height: 100),
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
