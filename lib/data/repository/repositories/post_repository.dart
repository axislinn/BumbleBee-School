import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bumblebee/models/post_model.dart';
import 'package:path/path.dart';

class ApiResponse {
  final bool success;
  final String? message;

  ApiResponse({required this.success, this.message});
}

class PostRepository {
  Future<ApiResponse> createPost(PostModel post, String schoolId, String token,
      List<String> imagePaths, List<String> documentPaths) async {
    final url =
        'https://bumblebeeflutterdeploy-production.up.railway.app/api/posts/create'; // Replace with your actual API URL
    final request = http.MultipartRequest('POST', Uri.parse(url));

    // Set headers for the request
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['schoolId'] = schoolId;
    request.fields['heading'] = post.heading;
    if (post.body != null) {
      request.fields['body'] = post.body!;
    }
    request.fields['contentType'] = post.contentType;
    if (post.classId != null) {
      request.fields['classId'] = post.classId!;
    }

    // Add each image file to the request
    for (var imagePath in imagePaths) {
      var picture = await http.MultipartFile.fromPath(
        'contentPictures', // Backend field for the images
        imagePath, // Get the path of each file
        filename: basename(imagePath), // Get the filename
      );
      request.files.add(picture);
    }

    // Add each document file to the request
    for (var documentPath in documentPaths) {
      var document = await http.MultipartFile.fromPath(
        'documents', // Backend field for the documents
        documentPath, // Get the path of each file
        filename: basename(documentPath), // Get the filename
      );
      request.files.add(document);
    }

    try {
      // Send the request
      var response = await request.send();

      // Parse the response
      final respStr = await response.stream.bytesToString();
      var jsonResponse = json.decode(respStr);

      // Log the response
      print("HTTP Status Code: ${response.statusCode}");
      print(
          "Response Body: $respStr"); // Log the full response body for debugging

      // Check for success
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Extract success and message from the response
        return ApiResponse(
          success: jsonResponse['con'] ?? false, // Capture success from 'con'
          message: jsonResponse['msg'], // Capture message from 'msg'
        );
      } else {
        // Log the entire jsonResponse on failure
        print("Failure Response: $jsonResponse"); // Log failure details
        return ApiResponse(
          success: false,
          message: jsonResponse['msg'] ??
              'Failed to create post', // Fallback message
        );
      }
    } catch (e) {
      print("HTTP error occurred: $e");
      return ApiResponse(success: false, message: 'An error occurred: $e');
    }
  }

  Future<List<PostModel>> fetchPosts(String? token) async {
    final url =
        'https://bumblebeeflutterdeploy-production.up.railway.app/api/posts/getFeeds';

    // Check if the token is null or empty
    if (token == null || token.isEmpty) {
      print("Error: Token is missing.");
      return []; // Or handle it as appropriate
    }

    try {
      print("Fetching posts from URL: $url with token: $token");
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print("Response body: ${response.body}");

      // Check the response status
      if (response.statusCode == 200) {
        // Parse the response body
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Debugging: Log the response structure
        print("Response structure: ${jsonResponse.keys}");

        // Check if the result field exists and has items
        if (jsonResponse.containsKey('result') &&
            jsonResponse['result'].containsKey('items')) {
          final List<dynamic> jsonPosts = jsonResponse['result']['items'];

          // Debugging: Log the number of posts fetched
          print("Number of posts fetched: ${jsonPosts.length}");

          // Convert the items to PostModel objects
          return jsonPosts.map((json) => PostModel.fromJson(json)).toList();
        } else {
          print("Key 'items' not found in 'result'");
          return [];
        }
      } else {
        print("Failed to fetch posts: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      // Debugging: Log any errors
      print("Error fetching posts: $e");
      return [];
    }
  }
}
