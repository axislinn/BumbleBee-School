import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bumblebee/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final String baseUrl =
      'https://bumblebeeflutterdeploy-production.up.railway.app';

  //Method for login
  Future<UserModel> authenticate(
      {required String email, required String password}) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    print('Attempting to authenticate user with email: $email');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print('Parsed JSON response: $jsonResponse');

      if (jsonResponse.containsKey('con') && jsonResponse['con'] == true) {
        String token = jsonResponse['result']['token'];
        print('Token: $token');

        // Extract schoolId from the `schools` list
        List<dynamic> schools =
            jsonResponse['result']['userInfo']['schools'] ?? [];
        String? schoolId = schools.isNotEmpty ? schools.first : null;
        print('School ID: $schoolId');

        // Check if token and schoolId are valid
        if (token.isEmpty || schoolId == null || schoolId.isEmpty) {
          throw Exception('Token or School ID is missing');
        }

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userToken', token);
        await prefs.setString('schoolId', schoolId);

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
    required String role,
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
        'roles': role,
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
      bool success = jsonResponse['con'] ?? false;
      if (success) {
        String token = jsonResponse['result']['token'] ?? '';
        print('Bearer Token: $token');

        if (token.isEmpty) {
          throw Exception('Token is missing');
        }

        Future<void> saveToken(String token) async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userToken', token);
        }

        await saveToken(token);

        var result = jsonResponse['result'];
        if (result != null && result['user'] != null) {
          // Ensure the user part exists and is valid
          return UserModel.fromJson(result['user']);
        } else {
          throw Exception('Failed to register: No user data found in response');
        }
      } else {
        String message = jsonResponse['msg'] ?? 'Unknown error occurred';
        throw Exception('Failed to register: $message');
      }
    } else {
      throw Exception('HTTP error: ${response.statusCode}, ${response.body}');
    }
  }
}
