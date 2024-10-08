import 'package:bumblebee_school/models/Admin+Teacher/class_model.dart';

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