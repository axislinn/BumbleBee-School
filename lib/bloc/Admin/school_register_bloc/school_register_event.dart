// school_event.dart

abstract class SchoolEvent {}

class RegisterSchool extends SchoolEvent {
  final String schoolName;
  final String address;
  final String phone;
  final String email;

  RegisterSchool({
    required this.schoolName,
    required this.address,
    required this.phone,
    required this.email,
  });
}
