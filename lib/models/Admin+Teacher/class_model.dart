// class Class {
//   final String id;
//   final String className;
//   final String grade;

//   Class({required this.id, required this.className, required this.grade});

// factory Class.fromJson(Map<String, dynamic> json) {
//   return Class(
//     id: json['id'] ?? '', // Handle null id by providing a default value
//     className: json['className'] ?? '',
//     grade: json['grade'] ?? '',
//   );
// }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'className': className,
//       'grade': grade,
//     };
//   }
// }


class Class {
  String id;
  String grade;
  String className;
  String classCode;
  String school; 
  List<String> students;
  List<String> teachers;
  List<String> guardians;
  List<String> announcements;

  Class({
    required this.id,
    required this.grade,
    required this.className,
    required this.classCode,
    required this.school,
    required this.students,
    required this.teachers,
    required this.guardians,
    required this.announcements,
  });

  // Factory method to create a ClassModel object from JSON
  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['_id'] ?? '',
      grade: json['grade'] ?? '',
      className: json['className'] ?? '',
      classCode: json['classCode'] ?? '',
      school: json['school'] ?? '', 
      students: List<String>.from(json['students']),
      teachers: List<String>.from(json['teachers']),
      guardians: List<String>.from(json['guardians']),
      announcements: List<String>.from(json['announcements']),
    );
  }

  // Method to convert a ClassModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'grade': grade,
      'className': className,
      'classCode': classCode,
      'school': school, 
      'students': students,
      'teachers': teachers,
      'guardians': guardians,
      'announcements': announcements,
    };
  }
}
