class School {
  final String schoolName;
  final String address;
  final String phone;
  final String email;

  School({
    required this.schoolName,
    required this.address,
    required this.phone,
    required this.email,
  });

  // a factory method to create a School object from a JSON map.
  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      schoolName: json['schoolName'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
    );
  }

  // convert a School object to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'schoolName': schoolName,
      'address': address,
      'phone': phone,
      'email': email,
    };
  }
}
