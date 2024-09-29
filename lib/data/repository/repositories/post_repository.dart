// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:bumblebee/models/post_model.dart';

// class PostRepository {
//   final String baseUrl =
//       'https://bumblebeeflutterdeploy-production.up.railway.app';

//   // Method to create a post
//   Future<ApiResponse> createPost(
//       PostModel post, String schoolId, String token) async {
//     final url = Uri.parse('$baseUrl/api/posts/create');

//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token', // Add token here
//         },
//         body: jsonEncode(post.toJson()), // Convert PostModel to JSON
//       );

//       // Log the full response details for debugging
//       print("HTTP Status Code: ${response.statusCode}");
//       print("Response Body: ${response.body}");

//       // Parse the JSON response
//       var jsonResponse = json.decode(response.body);

//       // Check if the response status code is successful (200, 201, etc.)
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return ApiResponse(
//             success: jsonResponse['con'], // Ensure this maps correctly
//             message: jsonResponse['msg']); // Map to your 'msg' field
//       } else {
//         // Log error and return the response as failed
//         print("Error: Failed to create post. Status: ${response.statusCode}");
//         return ApiResponse(
//             success: false,
//             message: jsonResponse['msg'] ?? 'Unknown error occurred');
//       }
//     } catch (e) {
//       // Catch and log any exceptions that occur during the HTTP call
//       print("HTTP error occurred: $e");
//       return ApiResponse(success: false, message: 'An exception occurred: $e');
//     }
//   }
// }

// class ApiResponse {
//   final bool success;
//   final String? message;

//   ApiResponse({required this.success, this.message});
// }

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:bumblebee/models/post_model.dart';
import 'package:path/path.dart'; // For getting filename from the path

class PostRepository {
  final String baseUrl =
      'https://bumblebeeflutterdeploy-production.up.railway.app';

  Future<ApiResponse> createPost(
      PostModel post, String schoolId, String token) async {
    final url = Uri.parse('$baseUrl/api/posts/create');

    try {
      var request = http.MultipartRequest('POST', url);

      // Add headers
      request.headers['Authorization'] = 'Bearer $token';

      // Add text fields (PostModel data)
      request.fields['heading'] = post.heading;
      request.fields['body'] = post.body!;
      request.fields['contentType'] = post.contentType;
      request.fields['classId'] = post.classId;
      request.fields['schoolId'] = post.schoolId;

      // Add image file if it exists
      if (post.contentPicture != null) {
        var picture = await http.MultipartFile.fromPath(
          'contentPicture', // Backend field for the image
          post.contentPicture!.path,
          filename: basename(post.contentPicture!.path), // Get filename
        );
        request.files.add(picture);
      }

      // Send the request
      var response = await request.send();

      // Parse the response
      final respStr = await response.stream.bytesToString();
      var jsonResponse = json.decode(respStr);

      // Log the response
      print("HTTP Status Code: ${response.statusCode}");
      print("Response Body: $respStr");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(
            success: jsonResponse['con'], message: jsonResponse['msg']);
      } else {
        return ApiResponse(
            success: false,
            message: jsonResponse['msg'] ?? 'Failed to create post');
      }
    } catch (e) {
      print("HTTP error occurred: $e");
      return ApiResponse(success: false, message: 'An error occurred: $e');
    }
  }
}

class ApiResponse {
  final bool success;
  final String? message;

  ApiResponse({required this.success, this.message});
}
