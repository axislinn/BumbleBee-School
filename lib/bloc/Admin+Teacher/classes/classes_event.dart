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

  AddClassEvent(this.className);

  @override
  List<Object> get props => [className];
}

class DeleteClassEvent extends ClassEvent {
  final String className;

  DeleteClassEvent(this.className);

  @override
  List<Object> get props => [className];
}
