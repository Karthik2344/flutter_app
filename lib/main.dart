// // ignore_for_file: avoid_print, library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert'; // For base64 encoding
// import 'dart:typed_data';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'PalmPower Textractor - Dashboard',
//       theme: ThemeData(
//         primaryColor: const Color(0xFF007A33),
//         hintColor: Colors.white,
//         textTheme: const TextTheme(
//           bodyMedium: TextStyle(color: Colors.black),
//         ),
//       ),
//       home: const DashboardPage(),
//     );
//   }
// }

// class DashboardPage extends StatefulWidget {
//   const DashboardPage({super.key});

//   @override
//   _DashboardPageState createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   int _selectedIndex = 0;
//   final titleController = TextEditingController();
//   final fieldController = TextEditingController();
//   Uint8List? _imageBytes; // To store the picked image bytes
//   String? _imageName; // To store the image name
//   String? _base64Image; // To store the Base64 encoded image

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   static const List<Widget> _widgetOptions = <Widget>[
//     Center(child: Text('Dashboard Content')),
//     Center(child: Text('Forms Content')),
//     Center(child: Text('Export Content')),
//   ];

//   // Function to pick an image using FilePicker
//   Future<void> _pickImage() async {
//     try {
//       // Use file_picker to select an image file
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.image,
//         allowMultiple: false,
//       );

//       if (result != null && result.files.single.bytes != null) {
//         setState(() {
//           _imageBytes = result.files.single.bytes;
//           _imageName = result.files.single.name;
//           _base64Image = base64Encode(_imageBytes!); // Convert to base64
//         });
//       } else {
//         print('No image selected.');
//       }
//     } catch (e) {
//       print('Error occurred while picking image: $e');
//     }
//   }

//   Future<void> _saveFormData() async {
//     final title = titleController.text;
//     final fields = fieldController.text;

//     if (title.isEmpty || fields.isEmpty || _base64Image == null) {
//       print('Please fill in all fields and select an image.');
//       return;
//     }

//     try {
//       final response = await http.post(
//         Uri.parse('http://localhost:5000/api/forms'), // Backend API URL
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'title': title,
//           'fields': fields,
//           'image': _base64Image, // Send the image as base64
//           'imageName': _imageName // Send the image name
//         }),
//       );

//       if (response.statusCode == 200) {
//         print('Form saved successfully: ${response.body}');
//         // Clear form after submission
//         titleController.clear();
//         fieldController.clear();
//         setState(() {
//           _imageBytes = null;
//           _imageName = null;
//           _base64Image = null;
//         });
//       } else {
//         print('Failed to save form: ${response.body}');
//       }
//     } catch (e) {
//       print('Error occurred while saving form data: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             Image.asset(
//               'assets/logo.png',
//               height: 50,
//               width: 50,
//               fit: BoxFit.contain,
//             ),
//             const SizedBox(width: 8),
//             const Text('PalmPower Textractor - Dashboard'),
//           ],
//         ),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Color(0xFF007A33),
//               ),
//               child: Text(
//                 'Dashboard Menu',
//                 style: TextStyle(
//                   fontSize: 24,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.settings),
//               title: const Text('Settings'),
//               onTap: () {},
//             ),
//             ListTile(
//               leading: const Icon(Icons.info),
//               title: const Text('About'),
//               onTap: () {},
//             ),
//             ListTile(
//               leading: const Icon(Icons.logout),
//               title: const Text('Logout'),
//               onTap: () {},
//             ),
//           ],
//         ),
//       ),
//       body: Center(
//         child: _selectedIndex == 1
//             ? Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     TextField(
//                       controller: titleController,
//                       decoration: const InputDecoration(hintText: 'Form Title'),
//                     ),
//                     const SizedBox(height: 10),
//                     TextField(
//                       controller: fieldController,
//                       decoration: const InputDecoration(hintText: 'Form Field'),
//                     ),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: _pickImage,
//                       child: const Text('Pick Image'),
//                     ),
//                     const SizedBox(height: 10),
//                     _imageBytes == null
//                         ? const Text('No image selected.')
//                         : Image.memory(_imageBytes!, height: 100),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: _saveFormData,
//                       child: const Text('Save Form'),
//                     ),
//                   ],
//                 ),
//               )
//             : _widgetOptions.elementAt(_selectedIndex),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.dashboard),
//             label: 'Dashboard',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.insert_drive_file),
//             label: 'Forms',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.upload_file),
//             label: 'Export',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: const Color(0xFF007A33),
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

// ignore_for_file: avoid_print, library_private_types_in_public_api

// ignore: duplicate_ignore
// ignore_for_file: avoid_print, library_private_types_in_public_api

//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
// import 'package:flutter/material.dart';
// import 'screens/dashboard_page.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'PalmPower Textractor - Dashboard',
//       theme: ThemeData(
//         primaryColor: const Color(0xFF007A33),
//         hintColor: Colors.white,
//         textTheme: const TextTheme(
//           bodyMedium: TextStyle(color: Colors.black),
//         ),
//       ),
//       debugShowCheckedModeBanner: false,
//       home: const DashboardPage(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/local_string.dart';
import 'package:new_app/screens/dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Localstring(), // Load the localized strings
      locale: const Locale('en', 'US'), // Set default locale
      fallbackLocale:
          const Locale('en', 'US'), // Fallback locale if translation not found
      title: 'PalmPower Textractor',
      theme: ThemeData(
        primaryColor: const Color(0xFF007A33),
        hintColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const DashboardPage(),
    );
  }
}
