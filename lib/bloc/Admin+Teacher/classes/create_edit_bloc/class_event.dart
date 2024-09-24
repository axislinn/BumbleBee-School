import 'package:bumblebee/models/Admin+Teacher/class_model.dart';
import 'package:bumblebee/models/Admin/school_model.dart';

abstract class ClassEvent {}

class LoadClasses extends ClassEvent {}

class CreateClass extends ClassEvent {
  final Class newClass;
  CreateClass(this.newClass);
}

class EditClass extends ClassEvent {
  final Map<String, dynamic> updatedClassData; // Accepts a Map
  EditClass(this.updatedClassData);
}


class DeleteClass extends ClassEvent {
  final String classId;
  DeleteClass(this.classId);
}

class FetchClassesEvent extends ClassEvent {}

class RequestToJoinClassEvent extends ClassEvent {
  final String classCode;

  RequestToJoinClassEvent(this.classCode);

  @override
  List<Object?> get props => [classCode];
}

class FetchStudentsEvent extends ClassEvent {
  final String classId;

  FetchStudentsEvent(this.classId);

  @override
  List<Object?> get props => [classId];
}

class AddStudentEvent extends ClassEvent {
  final String classId;
  final String studentName;
  final String dob;

  AddStudentEvent(this.classId, this.studentName, this.dob);

  @override
  List<Object?> get props => [classId, studentName, dob];
}

class FetchUserEvent extends ClassEvent {
  final String userId;

  FetchUserEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class FetchGuardiansEvent extends ClassEvent {
  final List<String> guardianIds;

  FetchGuardiansEvent(this.guardianIds);

  @override
  List<Object?> get props => [guardianIds];
}

class FetchPendingRequestsEvent extends ClassEvent {
  final String classId;
  final String studentId;

  FetchPendingRequestsEvent(this.classId, this.studentId);

  @override
  List<Object?> get props => [classId, studentId];
}