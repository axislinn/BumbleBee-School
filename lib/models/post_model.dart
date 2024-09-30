import 'dart:io';

class PostModel {
  final String heading;
  final String? body; // Optional field for post content
  final List<File>? contentPictures; // Changed to a list for multiple images
  final String contentType; // Required field for content type
  final int? reactions; // Optional field for reactions
  final String classId; // Required field for class ID
  final String schoolId; // Required field for school ID
  final DateTime? createdAt; // Optional field for creation date

  PostModel({
    required this.heading,
    this.body,
    this.contentPictures,
    required this.contentType,
    this.reactions,
    required this.classId,
    required this.schoolId,
    this.createdAt,
  });

  // Factory method to create a PostModel object from a JSON map
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      heading: json['heading'] ?? '', // Default to empty string if null
      body: json['body'], // No default needed
      contentPictures: json['contentPictures'] != null
          ? List<File>.from(json['contentPictures'].map((file) => File(file)))
          : null, // Convert list of file paths to List<File>
      contentType: json['contentType'] ?? '', // Default to empty string if null
      reactions: json['reactions'] != null ? json['reactions'] as int : null,
      classId: json['classId'] ?? '', // Default to empty string if null
      schoolId: json['schoolId'] ?? '', // Default to empty string if null
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null, // Convert to DateTime or null
    );
  }

  // Convert a PostModel object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'heading': heading,
      'body': body,
      'contentPictures': contentPictures
          ?.map((file) => file.path)
          .toList(), // Convert List<File> to list of paths
      'contentType': contentType,
      'reactions': reactions, // Send as integer or null
      'classId': classId,
      'schoolId': schoolId,
      'createdAt':
          createdAt?.toIso8601String(), // Convert DateTime to ISO 8601 string
    };
  }
}

class ApiResponse {
  final bool con; // Ensure this is always a boolean
  final String msg;
  final dynamic result;

  ApiResponse({
    required this.con,
    required this.msg,
    this.result,
  });

  // Factory method to create ApiResponse from JSON
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      con: json['con'] ?? false, // Default to 'false' if 'con' is null
      msg: json['msg'] ??
          '', // Ensure msg is a string, default to an empty string
      result: json['result'],
    );
  }
}
