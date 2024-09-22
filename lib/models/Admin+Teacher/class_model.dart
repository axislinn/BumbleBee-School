class ClassModel {
  String id;
  String grade;
  String className;
  String classCode;
  String school;
  List<String> students;
  List<String> teachers;
  List<String> guardians;
  List<String> announcements;

  ClassModel({
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

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
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
