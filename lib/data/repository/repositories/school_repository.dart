import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bumblebee/models/school_model.dart';

class SchoolRepository {
  static const String _baseUrl = 'https://bumblebeeflutterdeploy-production.up.railway.app';

  Future<void> registerSchool(School school, String token) async {
    final url = Uri.parse('$_baseUrl/api/school/create');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',  // Include Bearer token here
      },
      body: jsonEncode(school.toJson()),
    );

    if (response.statusCode != 200) {
      // Log response status and body for more detail
      print('Error registering school: ${response.statusCode} ${response.body}');
      throw Exception('Failed to register school. Status code: ${response.statusCode}. Error: ${response.body}');
    }
  }
}
