class Class {
  final String id;
  final String className;
  final String grade;

  Class({required this.id, required this.className, required this.grade});

factory Class.fromJson(Map<String, dynamic> json) {
  return Class(
    id: json['id'] ?? '', // Handle null id by providing a default value
    className: json['className'] ?? '',
    grade: json['grade'] ?? '',
  );
}


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'className': className,
      'grade': grade,
    };
  }
}
