import 'dart:convert';
import 'package:bumblebee/models/Admin+Teacher/class_model.dart';
import 'package:bumblebee/models/Admin+Teacher/student_model.dart';
import 'package:bumblebee/models/Admin+Teacher/user_model.dart';
import 'package:bumblebee/models/Admin/school_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (jsonResponse['result'] != null && jsonResponse['result']['classes'] != null) {
      List<dynamic> jsonList = jsonResponse['result']['classes'];     
      return jsonList.map((json) => StudentModel.fromJson(json)).toList();
    } else {   
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
      throw Exception('There are no classes registered'); 
    } else if (response.statusCode != 200) {
      print("This is not 200");
      throw Exception('Failed to get class data. Status code: ${response.statusCode}'); 
    }
    final Map<String, dynamic> data = jsonDecode(response.body);
    print(data['result']);
    List<dynamic> classesList = data['result']['classes'];
    print("testing $classesList");
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
    if (response.statusCode != 200) {
      throw Exception('Failed to join class. Status code: ${response.body}');
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
      final Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> classesList = data['result'];
      return classesList.map((json) => StudentModel.fromJson(json)).toList();
  }


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
  final Map<String, dynamic> data = jsonDecode(response.body);
 print("this is data $data");

  if (data['result'] != null) {

    List<dynamic> requests = data['result'];
    print("returned $requests");
    return requests.map((request) => UserModel.fromJson(request['sender'])).toList();
  }

  return []; 
}


  Future<UserModel> getUserById(String userId) async {
    final url = Uri.parse('$baseUrl/api/user/$userId');
    print('Fetching user data for userId: $userId');


    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    if (token == null) {
      throw Exception('No token found.');
    }

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print('Parsed JSON response: $jsonResponse');

      if (jsonResponse.containsKey('con') && jsonResponse['con'] == true) {

        return UserModel.fromJson(jsonResponse['result']);
      } else {
        print('Failed to fetch user info: ${jsonResponse['msg']}');
        throw Exception('Failed to fetch user info: ${jsonResponse['msg']}');
      }
    } else {
      print('HTTP error: ${response.statusCode}');
      throw Exception('HTTP error: ${response.statusCode}');
    }
  }
}