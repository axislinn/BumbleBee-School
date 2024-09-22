import 'package:bumblebee/bloc/Admin+Teacher/classes/bloc/class_event.dart';
import 'package:bumblebee/bloc/Admin+Teacher/classes/bloc/class_state.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/class_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassBloc extends Bloc<ClassEvent, ClassState> {
  final ClassRepository classRepository;

  ClassBloc(this.classRepository) : super(ClassInitial()) {
    on<LoadClasses>(_onLoadClasses);
    on<CreateClass>(_onCreateClass);
    on<EditClass>(_onEditClass);
    on<DeleteClass>(_onDeleteClass);
  }

  Future<void> _onLoadClasses(LoadClasses event, Emitter<ClassState> emit) async {
    emit(ClassLoading());
    try {
      final classes = await classRepository.fetchClasses();
      emit(ClassLoaded(classes));
    } catch (e) {
      emit(ClassError(e.toString()));
    }
  }

  Future<void> _onCreateClass(CreateClass event, Emitter<ClassState> emit) async {
    
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    if (token == null) {
      throw Exception('Authentication token not found');
    }

    try {
      await classRepository.createClass(event.newClass, token);
      add(LoadClasses());
    } catch (e) {
      emit(ClassError(e.toString()));
    }
  }

  Future<void> _onEditClass(EditClass event, Emitter<ClassState> emit) async {
    try {
      await classRepository.editClass(event.updatedClass);
      add(LoadClasses());
    } catch (e) {
      emit(ClassError(e.toString()));
    }
  }

  Future<void> _onDeleteClass(DeleteClass event, Emitter<ClassState> emit) async {
    try {
      await classRepository.deleteClass(event.classId);
      add(LoadClasses());
    } catch (e) {
      emit(ClassError(e.toString()));
    }
  }
}
