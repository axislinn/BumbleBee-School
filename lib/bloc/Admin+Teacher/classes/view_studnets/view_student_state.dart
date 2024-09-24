part of 'view_student_bloc.dart';

sealed class ViewStudentState extends Equatable {
  const ViewStudentState();
  
  @override
  List<Object> get props => [];
}

final class ViewStudentInitial extends ViewStudentState {}
