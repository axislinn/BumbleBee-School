import 'dart:convert';
import 'package:bumblebee/models/Admin+Teacher/class_model.dart';
import 'package:bumblebee/models/Admin/school_model.dart';
import 'package:http/http.dart' as http;

class ClassRepository {
  final String baseUrl = 'https://bumblebeeflutterdeploy-production.up.railway.app/api/class';

  Future<List<Class>> fetchClasses() async {
    final response = await http.get(Uri.parse('$baseUrl/list'));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Class.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load classes');
    }
  }

  Future<void> createClass(Class newClass, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', 
      },
      body: json.encode({
        'className': newClass.className,
        'grade': newClass.grade,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create class: ${response.body}');
    }
  }

  Future<void> editClass(Class updatedClass) async {
    final response = await http.put(
      Uri.parse('$baseUrl/edit/${updatedClass.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedClass.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to edit class');
    }
  }

  Future<void> deleteClass(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete class');
    }
  }
}
