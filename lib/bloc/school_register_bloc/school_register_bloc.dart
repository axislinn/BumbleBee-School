import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'school_register_event.dart';
part 'school_register_state.dart';

class SchoolRegisterBloc extends Bloc<SchoolRegisterEvent, SchoolRegisterState> {
  SchoolRegisterBloc() : super(SchoolRegisterInitial()) {
    on<SchoolRegisterEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
