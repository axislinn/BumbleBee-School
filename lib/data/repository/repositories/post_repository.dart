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
  ///create post method
  Future<ApiResponse> createPost(PostModel post, String schoolId, String token,
      List<String> imagePaths, List<String> documentPaths) async {
    // API endpoint URL
    final url =
        'https://bumblebeeflutterdeploy-production.up.railway.app/api/posts/create';
    final request = http.MultipartRequest('POST', Uri.parse(url));

    // Set headers for the request
    request.headers['Authorization'] = 'Bearer $token';

    // Add required fields to the request body
    request.fields['schoolId'] = schoolId;
    request.fields['heading'] = post.heading;

    if (post.body != null) {
      request.fields['body'] = post.body!;
    }

    request.fields['contentType'] = post.contentType;

    if (post.classId != null && post.classId.isNotEmpty) {
      request.fields['classId'] = post.classId;
    }

    // Add each image file to the request
    for (var imagePath in imagePaths) {
      var picture = await http.MultipartFile.fromPath(
        'contentPictures', // Backend field name for images
        imagePath, // Get the path of each file
        filename: basename(imagePath), // Use the filename
      );
      request.files.add(picture); // Add the image to the request
    }

    // Add each document file to the request
    for (var documentPath in documentPaths) {
      var document = await http.MultipartFile.fromPath(
        'documents', // Backend field name for documents
        documentPath, // Get the path of each file
        filename: basename(documentPath), // Use the filename
      );
      request.files.add(document); // Add the document to the request
    }

    try {
      // Send the request to the server
      var response = await request.send();

      // Convert the response stream to a string for processing
      final respStr = await response.stream.bytesToString();
      var jsonResponse = json.decode(respStr);

      // Log the HTTP status code and the response body for debugging
      print("HTTP Status Code: ${response.statusCode}");
      print("Response Body: $respStr");

      // Handle the response based on status code
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Return success response
        return ApiResponse(
          success:
              jsonResponse['con'] ?? false, // Check the 'con' field for success
          message: jsonResponse['msg'], // Get the message field
        );
      } else {
        // Log failure response for debugging
        print("Failure Response: $jsonResponse");
        return ApiResponse(
          success: false,
          message:
              jsonResponse['msg'] ?? 'Failed to create post', // Default message
        );
      }
    } catch (e) {
      // Catch and log any errors during the request
      print("HTTP error occurred: $e");
      return ApiResponse(success: false, message: 'An error occurred: $e');
    }
  }

  // Method to fetch posts with authentication token
  Future<List<PostModel>> fetchPosts(String? token) async {
    final url =
        'https://bumblebeeflutterdeploy-production.up.railway.app/api/posts/getFeeds'; // Your API URL

    try {
      // Debugging: Log the URL and token
      print("Fetching posts from URL: $url with token: $token");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token', // Include token for authorization
        },
      );

      // Debugging: Log the response body
      print("Response body: ${response.body}");

      // Check if the response was successful
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
