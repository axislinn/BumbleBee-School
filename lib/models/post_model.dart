// import 'dart:io';

// class PostModel {
//   final String heading;
//   final String? body; // Optional field for post content
//   final List<File>? contentPictures; // Changed to a list for multiple images
//   final String contentType; // Required field for content type
//   final int? reactions; // Optional field for reactions
//   final String classId; // Required field for class ID
//   final String schoolId; // Required field for school ID
//   final DateTime? createdAt; // Optional field for creation date
//   final User? postedBy; // Assuming you have a User model

//   PostModel({
//     required this.heading,
//     this.body,
//     this.contentPictures,
//     required this.contentType,
//     this.reactions,
//     required this.classId,
//     required this.schoolId,
//     this.createdAt,
//     this.postedBy,
//   });

//   // Factory method to create a PostModel object from a JSON map
//   factory PostModel.fromJson(Map<String, dynamic> json) {
//     return PostModel(
//       heading: json['heading'] ?? '', // Default to empty string if null
//       body: json['body'], // No default needed
//       contentPictures: json['contentPictures'] != null
//           ? List<File>.from(json['contentPictures'].map((file) => File(file)))
//           : null, // Convert list of file paths to List<File>
//       contentType: json['contentType'] ?? '', // Default to empty string if null
//       reactions: json['reactions'] != null ? json['reactions'] as int : null,
//       classId: json['classId'] ?? '', // Default to empty string if null
//       schoolId: json['schoolId'] ?? '', // Default to empty string if null
//       createdAt: json['createdAt'] != null
//           ? DateTime.parse(json['createdAt'])
//           : null, // Convert to DateTime or null
//     );
//   }

//   // Convert a PostModel object to a JSON map
//   Map<String, dynamic> toJson() {
//     return {
//       'heading': heading,
//       'body': body,
//       'contentPictures': contentPictures
//           ?.map((file) => file.path)
//           .toList(), // Convert List<File> to list of paths
//       'contentType': contentType,
//       'reactions': reactions, // Send as integer or null
//       'classId': classId,
//       'schoolId': schoolId,
//       'createdAt':
//           createdAt?.toIso8601String(), // Convert DateTime to ISO 8601 string
//     };
//   }
// }

// class User {
//   final String userName;
//   final String profilePicture;

//   User({
//     required this.userName,
//     required this.profilePicture,
//   });
// }

// class School {
//   final String id;
//   final String schoolName; // Add schoolName field

//   School(
//       {required this.id,
//       required this.schoolName}); // Add schoolName to constructor

//   // Factory method to create a School object from a JSON map
//   factory School.fromJson(Map<String, dynamic> json) {
//     return School(
//       id: json['_id'],
//       schoolName: json['schoolName'], // Add schoolName from JSON
//     );
//   }

//   // Convert a School object to a JSON map
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'schoolName': schoolName, // Serialize schoolName to JSON
//     };
//   }
// }

// class Class {
//   final String id;
//   final String className; // Add className field

//   Class(
//       {required this.id,
//       required this.className}); // Add className to constructor

//   // Factory method to create a Class object from a JSON map
//   factory Class.fromJson(Map<String, dynamic> json) {
//     return Class(
//       id: json['_id'],
//       className: json['className'], // Add className from JSON
//     );
//   }

//   // Convert a Class object to a JSON map
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'className': className, // Serialize className to JSON
//     };
//   }
// }

// class PostedBy {
//   final String userId;
//   final String userName;
//   final String profilePicture;

//   PostedBy({
//     required this.userId,
//     required this.userName,
//     required this.profilePicture,
//   });

//   // Factory method to create a PostedBy object from a JSON map
//   factory PostedBy.fromJson(Map<String, dynamic> json) {
//     return PostedBy(
//       userId: json['_id'] ?? '', // Default to empty string if null
//       userName: json['userName'] ?? '', // Default to empty string if null
//       profilePicture:
//           json['profilePicture'] ?? '', // Default to empty string if null
//     );
//   }

//   // Convert a PostedBy object to a JSON map
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': userId,
//       'userName': userName,
//       'profilePicture': profilePicture,
//     };
//   }
// }

// class ApiResponse {
//   final bool con; // Ensure this is always a boolean
//   final String msg;
//   final dynamic result;

//   ApiResponse({
//     required this.con,
//     required this.msg,
//     this.result,
//   });

//   // Factory method to create ApiResponse from JSON
//   factory ApiResponse.fromJson(Map<String, dynamic> json) {
//     return ApiResponse(
//       con: json['con'] ?? false, // Default to 'false' if 'con' is null
//       msg: json['msg'] ??
//           '', // Ensure msg is a string, default to an empty string
//       result: json['result'],
//     );
//   }
// }

class PostModel {
  final String? id;
  final String heading;
  final String? body; // Optional field for post content
  final List<String>? documents; // File paths for attached documents
  final List<String>? contentPictures; // Changed to a list for multiple images
  final String contentType; // Required field for content type
  final int? reactions; // Optional field for reactions
  final String? classId; // Changed to optional and might be an object
  final String? schoolId; // Changed to optional and might be an object
  final DateTime? createdAt; // Optional field for creation date
  final DateTime? updatedAt; // Added updatedAt field
  final PostedBy? postedBy; // Handling nested object

  // Optional references to School and Class objects
  final School? school; // Handle School as an object
  final ClassObj? classObj; // Renamed to avoid conflict with classId

  PostModel({
    this.id,
    required this.heading,
    this.body,
    this.contentPictures,
    this.documents,
    required this.contentType,
    this.reactions,
    this.classId,
    this.schoolId,
    this.createdAt,
    this.updatedAt,
    this.postedBy,
    this.school,
    this.classObj,
  });

  // Factory method to create a PostModel object from a JSON map
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['_id'],
      postedBy: json['posted_by'] != null
          ? PostedBy.fromJson(
              json['posted_by']) // Handling posted_by as an object
          : null,
      heading: json['heading'] ?? '',
      body: json['body'],
      contentPictures: json['contentPictures'] != null
          ? List<String>.from(json['contentPictures'])
          : null,
      documents: json['documents'] != null
          ? List<String>.from(json['documents'])
          : null,
      contentType: json['contentType'] ?? '',
      reactions: json['reactions'] ?? 0,
      classId: json['classId'] is Map<String, dynamic>
          ? ClassObj.fromJson(json['classId']).className // Parse as an object
          : json['classId'],
      schoolId: json['schoolId'] is Map<String, dynamic>
          ? School.fromJson(json['schoolId']).schoolName // Parse as an object
          : json['schoolId'],
      school: json['school'] != null
          ? School.fromJson(json['school']) // Parsing school object
          : null,
      classObj: json['class'] != null
          ? ClassObj.fromJson(json['class']) // Parsing class object
          : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  // Convert a PostModel object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'heading': heading,
      'body': body,
      'contentPictures': contentPictures,
      'documents': documents,
      'contentType': contentType,
      'reactions': reactions,
      'classId': classId,
      'schoolId': schoolId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'posted_by': postedBy?.toJson(),
    };
  }
}

// Model representing a User
class User {
  final String userName; // Required field for the user's name
  final String profilePicture; // Required field for user's profile picture URL

  User({
    required this.userName,
    required this.profilePicture,
  });

  // Factory method to create a User object from a JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userName: json['userName'], // Default to empty string if null
      profilePicture: json['profilePicture'], // Default to empty string if null
    );
  }

  // Convert a User object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'profilePicture': profilePicture, // Serialize profilePicture to JSON
    };
  }
}

// Model representing a School
class School {
  final String id; // Required field for school ID
  final String schoolName; // Required field for school name

  School({
    required this.id,
    required this.schoolName,
  });

  // Factory method to create a School object from a JSON map
  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['_id'], // Default to empty string if null
      schoolName: json['schoolName'], // Default to empty string if null
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

// Model representing a Class
class ClassObj {
  // Required field for class ID
  final String className; // Required field for class name

  ClassObj({
    required this.className,
  });

  // Factory method to create a Class object from a JSON map
  factory ClassObj.fromJson(Map<String, dynamic> json) {
    return ClassObj(
      className: json['className'] ?? '', // Default to empty string if null
    );
  }

  // Convert a Class object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'className': className, // Serialize className to JSON
    };
  }
}

// Model representing a post creator
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
      userId: json['_id'] ?? '',
      userName: json['userName'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
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

// Model representing an API response
class ApiResponse {
  final bool con;
  final String msg;
  final List<PostModel>? items;

  ApiResponse({
    required this.con,
    required this.msg,
    this.items,
  });

  // Factory method to create ApiResponse from JSON
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      con: json['con'] ?? false,
      msg: json['msg'] ?? '',
      items: json['result'] != null && json['result']['items'] != null
          ? List<PostModel>.from(
              json['result']['items'].map((item) => PostModel.fromJson(item)),
            )
          : null,
    );
  }
}
