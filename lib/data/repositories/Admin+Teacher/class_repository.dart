// class_repository.dart
import 'dart:convert';
import 'package:bumblebee/models/Admin+Teacher/class_model.dart';
import 'package:http/http.dart' as http;

class ClassRepository {
  final String baseUrl = 'https://bumblebeeflutterdeploy-production.up.railway.app';

  // Fetch all classes
  Future<List<ClassModel>> fetchClasses() async {
    final response = await http.get(Uri.parse('$baseUrl/api/class')); // Corrected URL
    if (response.statusCode == 200) {
      List<dynamic> classList = json.decode(response.body);
      return classList.map((c) => ClassModel.fromJson(c)).toList();
    } else {
      throw Exception('Failed to load classes');
    }
  }

  // Create a new class
  Future<void> createClass(ClassModel classModel) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/class/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(classModel.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create class');
    }
  }

  // Delete a class
  Future<void> deleteClass(String classId) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/class/delete/$classId')); // Corrected URL
    if (response.statusCode != 200) {
      throw Exception('Failed to delete class');
    }
  }
}
