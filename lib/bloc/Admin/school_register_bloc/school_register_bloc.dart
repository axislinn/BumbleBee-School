// school_bloc.dart

import 'package:bumblebee/bloc/Admin/school_register_bloc/school_register_event.dart';
import 'package:bumblebee/bloc/Admin/school_register_bloc/school_register_state.dart';
import 'package:bumblebee/data/repositories/Admin/school_repository.dart';
import 'package:bumblebee/models/Admin/school_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final school = School(
      schoolName: event.schoolName,
      address: event.address,
      phone: event.phone,
      email: event.email,
    );

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken'); 

    if (token == null) {
      throw Exception('Authentication token not found');
    }

    print('Retrieved token: $token');
    
    await schoolRepository.registerSchool(school, token);
    emit(SchoolSuccess());
  } catch (e) {
    emit(SchoolFailure(e.toString()));
  }
}

}