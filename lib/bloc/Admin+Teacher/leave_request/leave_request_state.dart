import 'package:bumblebee/models/Admin+Teacher/leave_req_model.dart';
import 'package:equatable/equatable.dart';

abstract class LeaveRequestState extends Equatable {
  @override
  List<Object> get props => [];
}

class LeaveRequestsLoadingState extends LeaveRequestState {}

class LeaveRequestsLoadedState extends LeaveRequestState {
  final List<LeaveRequest> leaveRequests;

  LeaveRequestsLoadedState(this.leaveRequests);

  @override
  List<Object> get props => [leaveRequests];
}

class LeaveRequestsErrorState extends LeaveRequestState {
  final String message;

  LeaveRequestsErrorState(this.message);

  @override
  List<Object> get props => [message];
}