part of 'school_register_bloc.dart';

sealed class SchoolRegisterState extends Equatable {
  const SchoolRegisterState();
  
  @override
  List<Object> get props => [];
}

final class SchoolRegisterInitial extends SchoolRegisterState {}
