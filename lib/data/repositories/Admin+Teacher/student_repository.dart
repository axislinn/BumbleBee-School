import 'dart:convert';
import 'package:bumblebee/models/Admin+Teacher/class_model.dart';
import 'package:bumblebee/models/Admin+Teacher/student_model.dart';
import 'package:bumblebee/models/Admin+Teacher/user_model.dart';
import 'package:http/http.dart' as http;

class StudentRepository {
  final String baseUrl = 'https://bumblebeeflutterdeploy-production.up.railway.app';

Future<List<StudentModel>> fetchClasses(String token) async {
  final response = await http.get(
    Uri.parse('$baseUrl/api/class/readByAdmin'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    // Decode the response body as a map
    Map<String, dynamic> jsonResponse = json.decode(response.body);

    // Check if 'result' and 'classes' are not null
    if (jsonResponse['result'] != null && jsonResponse['result']['classes'] != null) {
      List<dynamic> jsonList = jsonResponse['result']['classes'];

      // Map the list to Class objects and handle possible nulls in the JSON fields
      return jsonList.map((json) => StudentModel.fromJson(json)).toList();
    } else {
      // Handle the case where 'result' or 'classes' is null
      throw Exception('Invalid data: classes not found in response');
    }
  } else {
    print('Failed to load classes: ${response.statusCode} - ${response.body}');
    throw Exception('Failed to load classes');
  }
}


  Future<List<Class>> getClasses(String token) async {
    final url = Uri.parse('$baseUrl/api/class/readByTeacherAndGuardian');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 505) {
      print("This is 505");
      throw Exception('There are no classes registered'); // need to fix this. The screen displays "Error exception: There are no classes registered". There should be no "error exception"
    } else if (response.statusCode != 200) {
      print("This is not 200");
      throw Exception('Failed to get class data. Status code: ${response.statusCode}'); // status code wont be printed to the user. This is just for testing 
    }


    // Decode the response body
    final Map<String, dynamic> data = jsonDecode(response.body);

    print(data['result']);


    // Extract the list of classes from the "result" field
    List<dynamic> classesList = data['result']['classes'];

    print("testing $classesList");

    // Map the JSON data to a list of ClassModel objects
    return classesList.map((json) => Class.fromJson(json)).toList();

  }


    Future<void> requestToJoinClass(String token, String classCode) async {
    final url = Uri.parse('$baseUrl/api/request/create');
    

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'classCode': classCode}),
    );
    print("API sent"); // testing

    if (response.statusCode != 200) {
      throw Exception('Failed to join class. Status code: ${response.body}'); // used body because
    }

    final responseData = jsonDecode(response.body);
    print('Join class response: $responseData');
  }


Future<List<StudentModel>> getStudentsByClassId(String token, String classId) async {
    final url = Uri.parse('$baseUrl/api/student/get/$classId');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get student data. Status code: ${response.statusCode}');
    }

      // Decode the response body
      final Map<String, dynamic> data = jsonDecode(response.body);

      // Extract the list of classes from the "result" field
      List<dynamic> classesList = data['result'];

      // Map the JSON data to a list of StudentModel objects
      return classesList.map((json) => StudentModel.fromJson(json)).toList();
  }

  // Add a student to a class
Future<void> addStudentToClass(String token, String classId, String studentName, String studentDOB) async {
  final url = Uri.parse('$baseUrl/api/student/add/$classId');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'name': studentName,
       'dateofBirth': studentDOB,
    }),
  );

  if (response.statusCode != 200) {
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to add student to class. Status code: ${response.statusCode}');
  }

  final responseData = jsonDecode(response.body);
  print('Add student response: $responseData');
}



// Get pending guardian requests
Future<List<UserModel>> getPendingGuardianRequests(String token, String classId, String studentId) async {
  final url = Uri.parse('$baseUrl/api/request/read?classId=$classId&studentId=$studentId'); 

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  print("This is the status code ${response.statusCode}");

  if (response.statusCode != 200) {
    throw Exception('Failed to get guardian requests. Status code: ${response.statusCode}');
  }

  // Decode the response body
  final Map<String, dynamic> data = jsonDecode(response.body);

 print("this is data $data");

  // Check if the result is not empty
  if (data['result'] != null) {
    // Extract the sender data from the result and map to UserModel
    List<dynamic> requests = data['result'];
    print("returned $requests");
    return requests.map((request) => UserModel.fromJson(request['sender'])).toList();
  }

  return []; // Return an empty list if no requests are found
}



}