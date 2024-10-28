import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'register_page.dart';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorMessage;

  void _login() async {
    final success = await authService.login(emailController.text, passwordController.text);
    if (success) {
      // Navigate to dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
    } else {
      setState(() {
        errorMessage = "Login failed. Please check your credentials.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            ],
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                // Navigate to the registration page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
