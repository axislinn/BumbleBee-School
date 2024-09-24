class StudentModel {
  final String id;
  final String name;
  final String dateOfBirth;
  final List<String> schools;
  final List<String> classes;
  final List<String> guardians;

  StudentModel({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.schools,
    required this.classes,
    required this.guardians,
  });

  // Factory method to create a StudentModel object from JSON
  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['_id'],
      name: json['name'],
      dateOfBirth: json['dateofBirth'],
      schools: List<String>.from(json['schools']),   
      classes: List<String>.from(json['classes']),   
      guardians: List<String>.from(json['guardians']), 
    );
  }

  // Method to convert a StudentModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'dateofBirth': dateOfBirth,
      'schools': schools,
      'classes': classes,
      'guardians': guardians,
    };
  }
}
