// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_app/screens/forms_page.dart';
import 'package:new_app/widgets/custom_drawer.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static final List<Widget> _widgetOptions = <Widget>[
    Center(child: Text('dashboard_content'.tr)),
    const FormsPage(),
    Center(child: Text('export_content'.tr)),
  ];

  void _showLanguageSelectionDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('multilanguage_support'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () {
                Get.updateLocale(const Locale('en', 'US'));
                Get.back();
              },
            ),
            ListTile(
              title: const Text('हिन्दी'),
              onTap: () {
                Get.updateLocale(const Locale('hi', 'IN'));
                Get.back();
              },
            ),
            ListTile(
              title: const Text('తెలుగు'),
              onTap: () {
                Get.updateLocale(const Locale('te', 'IN'));
                Get.back();
              },
            ),
            ListTile(
              title: const Text('中文'),
              onTap: () {
                Get.updateLocale(const Locale('zh', 'CN'));
                Get.back();
              },
            ),
            ListTile(
              title: const Text('Español'),
              onTap: () {
                Get.updateLocale(const Locale('es', 'ES'));
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 50,
              width: 50,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            Text('app_title'.tr), // Removed const here
          ],
        ),
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (item) {
              if (item == 1) {
                _showLanguageSelectionDialog();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<int>(value: 0, child: Text('theme'.tr)),
              PopupMenuItem<int>(
                  value: 1, child: Text('multilanguage_support'.tr)),
            ],
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard),
            label: 'dashboard'.tr, // Removed const here
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.insert_drive_file),
            label: 'forms_page'.tr, // Removed const here
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.upload_file),
            label: 'export'.tr, // Removed const here
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF007A33),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class DashboardPage extends StatelessWidget {
//   const DashboardPage({super.key});

//   Future<void> _submitForm() async {
//     // Example of submitting form data to backend
//     final response = await http.post(
//       Uri.parse('http://localhost:5000/api/forms'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'title': 'Sample Form',
//         'fields': ['field1', 'field2'],
//         'image': 'base64EncodedImageHere',
//         'imageName': 'image.jpg',
//         'userId': 'exampleUserId',
//       }),
//     );

//     if (response.statusCode == 200) {
//       // Handle successful form submission
//     } else {
//       // Handle form submission error
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Dashboard')),
//       body: Center(
//         child: Column(
//           children: [
//             const Text('Welcome to the Dashboard!'),
//             ElevatedButton(onPressed: _submitForm, child: const Text('Submit Form')),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/login');
//               },
//               child: const Text('Logout'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
