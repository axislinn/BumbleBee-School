// class_events.dart
import 'package:equatable/equatable.dart';

abstract class ClassEvent extends Equatable {
  const ClassEvent();
  
  @override
  List<Object> get props => [];
}

class LoadClassesEvent extends ClassEvent {}

class AddClassEvent extends ClassEvent {
  final String className;
  final String grade;
  final String classCode;
  final String school;

  AddClassEvent({
    required this.className,
    required this.grade,
    required this.classCode,
    required this.school,
  });

  @override
  List<Object> get props => [className, grade, classCode, school];
}


class DeleteClassEvent extends ClassEvent {
  final String className;

  DeleteClassEvent(this.className);

  @override
  List<Object> get props => [className];
}
