import 'dart:io';

class PostModel {
  final String? id;
  final String heading;
  final String? body;
  final List<String>? contentPictures; // Use String instead of File
  final String contentType;
  final int? reactions;
  final String classId;
  final String schoolId;
  final List<String>? documents; // Use String instead of File
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final PostedBy? postedBy;

  PostModel({
    this.id,
    required this.heading,
    this.body,
    this.contentPictures, // Now it's a List<String> for URLs
    required this.contentType,
    this.reactions,
    required this.classId,
    required this.schoolId,
    this.documents, // Handle as List<String> for URLs
    this.createdAt,
    this.updatedAt,
    this.postedBy,
  });

  // Factory method to create a PostModel object from a JSON map
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['_id'],
      heading: json['heading'] ?? '',
      body: json['body'],
      contentPictures: json['contentPictures'] != null
          ? List<String>.from(
              json['contentPictures']) // Use String instead of File
          : null,
      contentType: json['contentType'] ?? '',
      reactions: json['reactions'] != null ? json['reactions'] as int : 0,
      classId: json['classId'] ?? '',
      schoolId: json['schoolId'] ?? '',
      documents: json['documents'] != null
          ? List<String>.from(json['documents']) // Use String instead of File
          : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      postedBy: json['posted_by'] != null
          ? PostedBy.fromJson(json['posted_by'])
          : null,
    );
  }

  // Convert a PostModel object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'heading': heading,
      'body': body,
      'contentPictures': contentPictures, // No need to map file paths
      'contentType': contentType,
      'reactions': reactions,
      'classId': classId,
      'schoolId': schoolId,
      'documents': documents, // Handle documents
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'posted_by': postedBy?.toJson(),
    };
  }
}

class PostedBy {
  final String userId;
  final String userName;
  final String profilePicture;

  PostedBy({
    required this.userId,
    required this.userName,
    required this.profilePicture,
  });

  // Factory method to create a PostedBy object from a JSON map
  factory PostedBy.fromJson(Map<String, dynamic> json) {
    return PostedBy(
      userId: json['_id'] ?? '', // Default to empty string if null
      userName: json['userName'] ?? '', // Default to empty string if null
      profilePicture:
          json['profilePicture'] ?? '', // Default to empty string if null
    );
  }

  // Convert a PostedBy object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      '_id': userId,
      'userName': userName,
      'profilePicture': profilePicture,
    };
  }
}

class ApiResponse<T> {
  final bool con; // Ensure this is always a boolean
  final String msg;
  final T? result; // Use generics for result type
  final int? statusCode; // Optional field for status code

  ApiResponse({
    required this.con,
    required this.msg,
    this.result,
    this.statusCode,
  });

  // Factory method to create ApiResponse from JSON
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      con: json['con'] ?? false,
      msg: json['msg'] ?? '',
      result:
          json['result'], // Result can be of any type, so handle it dynamically
      statusCode: json['statusCode'], // Optional statusCode
    );
  }

  // Convert an ApiResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'con': con,
      'msg': msg,
      'result': result,
      'statusCode': statusCode, // Include statusCode if available
    };
  }
}
