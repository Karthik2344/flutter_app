import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl =
      'http://localhost:5000/api'; // Change to your server URL

  Future<bool> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username, // Include username
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      // User registered successfully
      return true;
    } else {
      // Optionally, log the error response
      json.decode(response.body);
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Optionally, handle the response body if needed
      // For example, extracting a token or user info
      // final data = json.decode(response.body);
      // Save token and user info if needed
      return true;
    } else {
      // Optionally, log the error response
      json.decode(response.body);
      return false;
    }
  }
}
