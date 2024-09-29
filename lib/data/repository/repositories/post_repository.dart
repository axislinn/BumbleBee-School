import 'dart:convert';
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
