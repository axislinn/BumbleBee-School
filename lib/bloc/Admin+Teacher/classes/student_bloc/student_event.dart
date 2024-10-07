part of 'student_bloc.dart';

abstract class StudentEvent {}

class FetchClassesEvent extends StudentEvent {}

class RequestToJoinClassEvent extends StudentEvent {
  final String classCode;

  RequestToJoinClassEvent(this.classCode);

  @override
  List<Object?> get props => [classCode];
}

class FetchStudentsEvent extends StudentEvent {
  final String classId;

  FetchStudentsEvent(this.classId);

  @override
  List<Object?> get props => [classId];
}

class AddStudentEvent extends StudentEvent {
  final String classId;
  final String studentName;
  final String dob;

  AddStudentEvent(this.classId, this.studentName, this.dob);

  @override
  List<Object?> get props => [classId, studentName, dob];
}

class FetchUserEvent extends StudentEvent {
  final String userId;

  FetchUserEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class FetchGuardiansEvent extends StudentEvent {
  final List<String> guardianIds;

  FetchGuardiansEvent(this.guardianIds);

  @override
  List<Object?> get props => [guardianIds];
}

class FetchPendingRequestsEvent extends StudentEvent {
  final String classId;
  final String studentId;

  FetchPendingRequestsEvent(this.classId, this.studentId);

  @override
  List<Object?> get props => [classId, studentId];
}