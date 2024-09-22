import 'package:bumblebee/models/Admin+Teacher/class_model.dart';
import 'package:equatable/equatable.dart';

abstract class ClassState extends Equatable {
  const ClassState();
  
  @override
  List<Object> get props => [];
}

class ClassInitial extends ClassState {}

class ClassesLoaded extends ClassState {
  final List<ClassModel> classes;

  ClassesLoaded(this.classes);

  @override
  List<Object> get props => [classes];
}

class ClassError extends ClassState {
  final String message;

  ClassError(this.message);

  @override
  List<Object> get props => [message];
}
