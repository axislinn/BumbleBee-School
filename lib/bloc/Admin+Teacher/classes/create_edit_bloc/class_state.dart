import 'package:bumblebee/models/Admin+Teacher/class_model.dart';
import 'package:bumblebee/models/Admin+Teacher/student_model.dart';
import 'package:bumblebee/models/Admin+Teacher/user_model.dart';
import 'package:bumblebee/models/Admin/school_model.dart';

abstract class ClassState {}

class ClassInitial extends ClassState {}

class ClassLoading extends ClassState {}

class ClassLoaded extends ClassState {
  final List<Class> classes;
  ClassLoaded(this.classes);
}

class ClassError extends ClassState {
  final String message;
  ClassError(this.message);
}

class ClassLoadingState extends ClassState {}

class ClassLoadedState extends ClassState {
  final List<Class> classes;

  ClassLoadedState(this.classes);

  @override
  List<Object?> get props => [classes];
}

class ClassErrorState extends ClassState {
  final String message;

  ClassErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class JoinClassSuccessState extends ClassState {}

class JoinClassErrorState extends ClassState {
  final String message;

  JoinClassErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class StudentsLoadedState extends ClassState {
  final List<StudentModel> students;

  StudentsLoadedState(this.students);

  @override
  List<Object?> get props => [students];
}

class StudentsLoadingState extends ClassState {}

class StudentsErrorState extends ClassState {
  final String message;

  StudentsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class AddStudentSuccessState extends ClassState {}

class AddStudentErrorState extends ClassState {
  final String message;

  AddStudentErrorState(this.message);
}

class UserLoadingState extends ClassState {}

class UserLoadedState extends ClassState {
  final UserModel user;

  UserLoadedState(this.user);

  @override
  List<Object?> get props => [user];
}

class UserErrorState extends ClassState {
  final String message;

  UserErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

// States related to guardians
class GuardiansLoadingState extends ClassState {}

class GuardiansLoadedState extends ClassState {
  final List<UserModel> guardians;

  GuardiansLoadedState(this.guardians);

  @override
  List<Object?> get props => [guardians];
}

class GuardiansErrorState extends ClassState {
  final String message;

  GuardiansErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class PendingRequestsLoadingState extends ClassState {}

class PendingRequestsLoadedState extends ClassState {
  final List<UserModel> pendingRequests;

  PendingRequestsLoadedState(this.pendingRequests);

  @override
  List<Object?> get props => [pendingRequests];
}

class PendingRequestsErrorState extends ClassState {
  final String message;

  PendingRequestsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}