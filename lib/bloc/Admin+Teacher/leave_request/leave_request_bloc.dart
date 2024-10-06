import 'package:bumblebee/bloc/Admin+Teacher/leave_request/leave_request_event.dart';
import 'package:bumblebee/bloc/Admin+Teacher/leave_request/leave_request_state.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/leave_req_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaveRequestBloc extends Bloc<LeaveRequestEvent, LeaveRequestState> {
  final LeaveRequestRepository leaveRequestRepository;

  LeaveRequestBloc(this.leaveRequestRepository) : super(LeaveRequestsLoadingState());

  @override
  Stream<LeaveRequestState> mapEventToState(LeaveRequestEvent event) async* {
    if (event is FetchLeaveRequestsEvent) {
      yield LeaveRequestsLoadingState();
      try {
        final leaveRequests = await leaveRequestRepository.getLeaveRequestsByClass(event.classId);
        yield LeaveRequestsLoadedState(leaveRequests);
      } catch (e) {
        yield LeaveRequestsErrorState(e.toString());
      }
    }
  }
}