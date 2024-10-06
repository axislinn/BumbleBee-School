import 'dart:convert';
import 'package:bumblebee/models/Admin+Teacher/leave_req_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LeaveRequestRepository {
  final String baseUrl = 'https://bumblebeeflutterdeploy-production.up.railway.app';

  Future<List<LeaveRequest>> getLeaveRequestsByClass(String classId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Retrieve the token from SharedPreferences

    final url = '$baseUrl/api/leaveRequest/readByClass/$classId';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Send the token in the request header
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['con'] == true) {
        // Parse the 'result' field which contains the list of leave requests
        List<dynamic> result = data['result'];
        List<LeaveRequest> leaveRequests = result.map((json) => LeaveRequest.fromJson(json)).toList();
        return leaveRequests;
      } else {
        throw Exception('Failed to fetch leave requests: ${data['msg']}');
      }
    } else {
      throw Exception('Failed to load leave requests');
    }
  }
}
