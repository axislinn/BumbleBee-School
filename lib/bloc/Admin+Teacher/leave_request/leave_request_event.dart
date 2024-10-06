import 'package:equatable/equatable.dart';

abstract class LeaveRequestEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchLeaveRequestsEvent extends LeaveRequestEvent {
  final String classId;

  FetchLeaveRequestsEvent(this.classId);

  @override
  List<Object> get props => [classId];
}