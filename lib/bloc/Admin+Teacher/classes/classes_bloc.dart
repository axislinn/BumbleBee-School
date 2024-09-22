// class_bloc.dart
import 'package:bumblebee/bloc/Admin+Teacher/classes/classes_event.dart';
import 'package:bumblebee/bloc/Admin+Teacher/classes/classes_state.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/class_repository.dart';
import 'package:bumblebee/models/Admin+Teacher/class_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassBloc extends Bloc<ClassEvent, ClassState> {
  final ClassRepository classRepository;

  ClassBloc(this.classRepository) : super(ClassInitial()) {
    on<LoadClassesEvent>((event, emit) async {
      try {
        final classes = await classRepository.fetchClasses();
        emit(ClassesLoaded(classes));
      } catch (error) {
        emit(ClassError("Failed to load classes"));
      }
    });

    on<AddClassEvent>((event, emit) async {
      try {
        final newClass = ClassModel(
          id: '', // Set an appropriate ID if needed
          grade: '', // Set other fields accordingly
          className: event.className,
          classCode: '', // Set other fields accordingly
          school: '', // Set other fields accordingly
          students: [],
          teachers: [],
          guardians: [],
          announcements: [],
        );
        await classRepository.createClass(newClass);
        final classes = await classRepository.fetchClasses();
        emit(ClassesLoaded(classes));
      } catch (error) {
        emit(ClassError("Failed to add class"));
      }
    });

    on<DeleteClassEvent>((event, emit) async {
      try {
        await classRepository.deleteClass(event.className);
        final classes = await classRepository.fetchClasses();
        emit(ClassesLoaded(classes));
      } catch (error) {
        emit(ClassError("Failed to delete class"));
      }
    });
  }
}