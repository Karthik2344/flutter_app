import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService authService = AuthService();
  final TextEditingController usernameController =
      TextEditingController(); // Controller for username
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? successMessage;
  String? errorMessage;

  void _register() async {
    final success = await authService.register(
      usernameController.text, // Pass username
      emailController.text,
      passwordController.text,
    );
    if (success) {
      setState(() {
        successMessage = "Registration successful. You can now log in.";
        errorMessage = null;
      });
    } else {
      setState(() {
        errorMessage = "Registration failed. Please try again.";
        successMessage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController, // Username field
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            if (successMessage != null) ...[
              const SizedBox(height: 10),
              Text(successMessage!,
                  style: const TextStyle(color: Colors.green)),
            ],
            if (errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            ],
            ElevatedButton(
              onPressed: _register,
              child: const Text('Register'),
            ),
            TextButton(
              onPressed: () {
                // Navigate back to the login page
                Navigator.pop(context);
              },
              child: const Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
