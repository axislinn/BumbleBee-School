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