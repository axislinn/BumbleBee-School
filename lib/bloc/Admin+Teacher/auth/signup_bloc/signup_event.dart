import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RegisterButtonPressed extends RegisterEvent {
  final String userName;
  final String email;
  final String password;
  final String confirmPassword;
  final String phone;
  final String role;  // Add role field
  // final String relationship;

  RegisterButtonPressed({
    required this.userName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phone,
    required this.role,  // Pass role to the event
    // required this.relationship,
  });

  @override
  List<Object> get props => [userName, email, password, confirmPassword, phone];
}
