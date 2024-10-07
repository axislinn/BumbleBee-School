part of 'student_bloc.dart';



final class StudentInitial extends StudentState {}

abstract class StudentState {}

class ClassInitial extends StudentState {}

class ClassLoading extends StudentState {}

class ClassLoaded extends StudentState {
  final List<Class> classes;
  ClassLoaded(this.classes);
}

class ClassError extends StudentState {
  final String message;
  ClassError(this.message);
}

class ClassLoadingState extends StudentState {}

class ClassLoadedState extends StudentState {
  final List<Class> classes;

  ClassLoadedState(this.classes);

  @override
  List<Object?> get props => [classes];
}

class ClassErrorState extends StudentState {
  final String message;

  ClassErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class JoinClassSuccessState extends StudentState {}

class JoinClassErrorState extends StudentState {
  final String message;

  JoinClassErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class StudentsLoadedState extends StudentState {
  final List<StudentModel> students;

  StudentsLoadedState(this.students);

  @override
  List<Object?> get props => [students];
}

class StudentsLoadingState extends StudentState {}

class StudentsErrorState extends StudentState {
  final String message;

  StudentsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class AddStudentSuccessState extends StudentState {}

class AddStudentErrorState extends StudentState {
  final String message;

  AddStudentErrorState(this.message);
}

class UserLoadingState extends StudentState {}

class UserLoadedState extends StudentState {
  final UserModel user;

  UserLoadedState(this.user);

  @override
  List<Object?> get props => [user];
}

class UserErrorState extends StudentState {
  final String message;

  UserErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

// States related to guardians
class GuardiansLoadingState extends StudentState {}

class GuardiansLoadedState extends StudentState {
  final List<UserModel> guardians;

  GuardiansLoadedState(this.guardians);

  @override
  List<Object?> get props => [guardians];
}

class GuardiansErrorState extends StudentState {
  final String message;

  GuardiansErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class PendingRequestsLoadingState extends StudentState {}

class PendingRequestsLoadedState extends StudentState {
  final List<UserModel> pendingRequests;

  PendingRequestsLoadedState(this.pendingRequests);

  @override
  List<Object?> get props => [pendingRequests];
}

class PendingRequestsErrorState extends StudentState {
  final String message;

  PendingRequestsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}