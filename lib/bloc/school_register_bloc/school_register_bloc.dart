// school_bloc.dart

import 'package:bumblebee/bloc/school_register_bloc/school_register_event.dart';
import 'package:bumblebee/bloc/school_register_bloc/school_register_state.dart';
import 'package:bumblebee/data/repository/repositories/school_repository.dart';
import 'package:bumblebee/models/school_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SchoolBloc extends Bloc<SchoolEvent, SchoolState> {
  final SchoolRepository schoolRepository;

  SchoolBloc({required this.schoolRepository}) : super(SchoolInitial()) {
    on<RegisterSchool>(_onRegisterSchool);
  }

  Future<void> _onRegisterSchool(
    RegisterSchool event,
    Emitter<SchoolState> emit,
  ) async {
    emit(SchoolLoading());

    try {
      // Create a School object from the event data
      final school = School(
        schoolName: event.schoolName,
        address: event.address,
        phone: event.phone,
        email: event.email,
      );

      await schoolRepository.registerSchool(school);
      emit(SchoolSuccess());
    } catch (e) {
      emit(SchoolFailure(e.toString()));
    }
  }
}
