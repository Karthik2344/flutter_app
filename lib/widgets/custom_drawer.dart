import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  void _logout() {
    Get.offAllNamed('/login'); // Using Get for navigation
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.green,
            ),
            child: Text(
              'dashboard_menu'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('settings'.tr),
            onTap: () {
              Get.toNamed('/settings'); // Navigate to SettingsPage
            },
          ),
          ListTile(
            title: Text('about'.tr),
            onTap: () {
              Get.toNamed('/about'); // Navigate to AboutPage
            },
          ),
          const Divider(),
          ListTile(
            title: Text('logout'.tr),
            onTap: _logout, // Call logout function to navigate to login page
          ),
        ],
      ),
    );
  }
}
