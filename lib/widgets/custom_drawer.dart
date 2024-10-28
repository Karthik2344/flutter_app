import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  void _logout(BuildContext context) {
    // Implement logout functionality here
    // For example, clear the user token and navigate to the login page
    // Assuming you're using a navigation method to go to login page

    // Clear user data (token, etc.) if you're saving it locally
    // For example: AuthService.clearUserData();

    // Navigate back to login page
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Dashboard Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              // Navigate to settings page
              Navigator.pop(context); // Close the drawer
              Navigator.pushNamed(
                  context, '/settings'); // Replace with your settings route
            },
          ),
          ListTile(
            title: const Text('About'),
            onTap: () {
              // Navigate to about page
              Navigator.pop(context); // Close the drawer
              Navigator.pushNamed(
                  context, '/about'); // Replace with your about route
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              _logout(context); // Call the logout function
            },
          ),
        ],
      ),
    );
  }
}
