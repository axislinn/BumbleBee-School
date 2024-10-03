import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bumblebee/models/Admin+Teacher/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final String baseUrl = 'https://bumblebeeflutterdeploy-production.up.railway.app';
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<UserModel> authenticate({required String email, required String password}) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    print('Attempting to authenticate user with email: $email');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print('Parsed JSON response: $jsonResponse');

      if (jsonResponse['con'] == true) {
        String token = jsonResponse['result']['token'];
        print('Bearer Token: $token');

        // Save the token securely
        await secureStorage.write(key: 'userToken', value: token); // Consistent key usage

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userToken', token);

        return UserModel.fromJson(jsonResponse['result']['userInfo']);
      } else {
        print('Login failed: ${jsonResponse['msg']}');
        throw Exception('Login failed: ${jsonResponse['msg']}');
      }
    } else {
      print('HTTP error: ${response.statusCode}');
      throw Exception('HTTP error: ${response.statusCode}');
    }
  }

//mwthod for sign up
Future<UserModel> register({
  required String userName,
  required String email,
  required String password,
  required String confirmedPassword,
  required String phone,
  required String role,  // Add role to method signature
  // required String relationship,
}) async {
  final url = Uri.parse('$baseUrl/api/auth/register');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'userName': userName,
      'email': email,
      'password': password,
      'confirmedPassword': confirmedPassword,
      'phone': phone,
      'roles': role,  // Pass role to API
      // 'relationship': relationship,
    }),
  );

    // Print response details for debugging
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    // Parse the response
    var jsonResponse = json.decode(response.body);

    // Print parsed JSON for further inspection
    print('Parsed JSON response: $jsonResponse');

    if (response.statusCode == 200) {
      // Check if `con` field exists and is a boolean
      bool success = jsonResponse['con'] ?? false;
      if (success) {
        String token = jsonResponse['result']['token'];
        print('Bearer Token: $token');

        Future<void> saveToken(String token) async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userToken', token);
        }

        // Handle successful registration
        var result = jsonResponse['result'];
        if (result != null && result['user'] != null) {
          // Assuming UserModel.fromJson handles the `user` part of the result
          return UserModel.fromJson(result['user']);
        } else {
          throw Exception('Failed to register: No user data found in response');
        }
      } else {
        // Handle failure scenario based on `msg`
        String message = jsonResponse['msg'] ?? 'Unknown error occurred';
        throw Exception('Failed to register: $message');
      }
    } else {
      // Handle non-200 responses
      throw Exception('HTTP error: ${response.statusCode}, ${response.body}');
    }
  }



}
