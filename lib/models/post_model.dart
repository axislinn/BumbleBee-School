class PostModel {
  final String? id;
  final String heading;
  final String? body;
  final List<String>? contentPictures; // Use String instead of File
  final String contentType;
  final int? reactions;
  final School? schoolId; // Changed to School object
  final Class? classId; // Changed to Class object
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
    this.classId, // Changed to Class object
    this.schoolId, // Changed to School object
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
      classId: json['classId'] != null
          ? Class.fromJson(json['classId']) // Now expects an object
          : null,
      schoolId: json['schoolId'] != null
          ? School.fromJson(json['schoolId']) // Now expects an object
          : null,
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
      'classId': classId?.toJson(), // Serialize Class object
      'schoolId': schoolId?.toJson(), // Serialize School object
      'documents': documents, // Handle documents
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'posted_by': postedBy?.toJson(),
    };
  }
}

class School {
  final String id;
  final String schoolName; // Add schoolName field

  School(
      {required this.id,
      required this.schoolName}); // Add schoolName to constructor

  // Factory method to create a School object from a JSON map
  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['_id'],
      schoolName: json['schoolName'], // Add schoolName from JSON
    );
  }

  // Convert a School object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'schoolName': schoolName, // Serialize schoolName to JSON
    };
  }
}

class Class {
  final String id;
  final String className; // Add className field

  Class(
      {required this.id,
      required this.className}); // Add className to constructor

  // Factory method to create a Class object from a JSON map
  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['_id'],
      className: json['className'], // Add className from JSON
    );
  }

  // Convert a Class object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'className': className, // Serialize className to JSON
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
  final bool con;
  final String msg;
  final T? result;
  final int? statusCode;

  ApiResponse({
    required this.con,
    required this.msg,
    this.result,
    this.statusCode,
  });

  // Factory method to create ApiResponse from JSON, handling different types
  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic json) create) {
    return ApiResponse(
      con: json['con'] ?? false,
      msg: json['msg'] ?? '',
      result: json['result'] != null ? create(json['result']) : null,
      statusCode: json['statusCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'con': con,
      'msg': msg,
      'result': result,
      'statusCode': statusCode,
    };
  }
}
