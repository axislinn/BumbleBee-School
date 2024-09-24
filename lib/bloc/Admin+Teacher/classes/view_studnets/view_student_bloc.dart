import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'view_student_event.dart';
part 'view_student_state.dart';

class ViewStudentBloc extends Bloc<ViewStudentEvent, ViewStudentState> {
  ViewStudentBloc() : super(ViewStudentInitial()) {
    on<ViewStudentEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
