// school_state.dart

abstract class SchoolState {}

class SchoolInitial extends SchoolState {}

class SchoolLoading extends SchoolState {}

class SchoolSuccess extends SchoolState {}

class SchoolFailure extends SchoolState {
  final String error;

  SchoolFailure(this.error);
}
