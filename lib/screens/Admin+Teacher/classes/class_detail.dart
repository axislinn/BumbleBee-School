import 'package:bumblebee/bloc/Admin+Teacher/classes/student_bloc/student_bloc.dart';
import 'package:bumblebee/bloc/Admin+Teacher/leave_request/leave_request_bloc.dart';
import 'package:bumblebee/bloc/Admin+Teacher/leave_request/leave_request_event.dart';
import 'package:bumblebee/bloc/Admin+Teacher/leave_request/leave_request_state.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/class_repository.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/leave_req_repository.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/student_repository.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/user_repository.dart';
import 'package:bumblebee/models/Admin+Teacher/leave_req_model.dart';
import 'package:bumblebee/models/Admin+Teacher/student_model.dart';
import 'package:bumblebee/screens/Admin+Teacher/classes/add_student_to_class.dart';
import 'package:bumblebee/screens/Admin+Teacher/classes/student_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentList extends StatefulWidget {
  final String classId;

  const StudentList({Key? key, required this.classId}) : super(key: key);

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  late StudentBloc _studentBloc;
  late LeaveRequestBloc _leaveRequestBloc;

  @override
  void initState() {
    super.initState();
    _studentBloc = StudentBloc(ClassRepository(), UserRepository(), StudentRepository());
    _leaveRequestBloc = LeaveRequestBloc(LeaveRequestRepository());

    _fetchStudents();
    _fetchLeaveRequests();
  }

  void _fetchStudents() {
    _studentBloc.add(FetchStudentsEvent(widget.classId));
  }

  void _fetchLeaveRequests() {
    _leaveRequestBloc.add(FetchLeaveRequestsEvent(widget.classId));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<StudentBloc>.value(value: _studentBloc),
        BlocProvider<LeaveRequestBloc>.value(value: _leaveRequestBloc),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Class Detail'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _navigateToAddStudentToClass,
          child: Icon(Icons.add),
          tooltip: 'Add Student',
        ),
        body: Column(
          children: [
            _buildLeaveRequestsSection(),
            Expanded(
              child: _buildStudentsSection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveRequestsSection() {
    return BlocBuilder<LeaveRequestBloc, LeaveRequestState>(
      builder: (context, state) {
        if (state is LeaveRequestsLoadingState) {
          return _buildLoadingIndicator();
        } else if (state is LeaveRequestsErrorState) {
          return _buildErrorMessage(state.message);
        } else if (state is LeaveRequestsLoadedState) {
          return _buildLeaveRequestList(state.leaveRequests);
        }
        return _buildEmptyMessage();
      },
    );
  }

  Widget _buildLeaveRequestList(List<LeaveRequest> leaveRequests) {
    if (leaveRequests.isEmpty) {
      return Center(child: Text('No leave requests found.'));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: leaveRequests.length,
      itemBuilder: (context, index) {
        final leaveRequest = leaveRequests[index];
        return ListTile(
          title: Text('${leaveRequest.reason} (${leaveRequest.startDate} - ${leaveRequest.endDate})'),
          subtitle: Text(leaveRequest.description),
        );
      },
    );
  }

  Widget _buildStudentsSection() {
    return BlocBuilder<StudentBloc, StudentState>(
      builder: (context, state) {
        if (state is StudentsLoadingState) {
          return _buildLoadingIndicator();
        } else if (state is StudentsErrorState) {
          return _buildErrorMessage(state.message);
        } else if (state is StudentsLoadedState) {
          return _buildStudentList(state.students);
        }
        return _buildEmptyMessage();
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorMessage(String message) {
    return Center(child: Text('Error: $message'));
  }

  Widget _buildStudentList(List<StudentModel> students) {
    if (students.isEmpty) {
      return Center(child: Text('No students found.'));
    }

    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return ListTile(
          title: Text(student.name),
          onTap: () => _navigateToStudentDetail(
            student.name,
            student.dateOfBirth,
            student.guardians,
            widget.classId,
            student.id,
          ),
        );
      },
    );
  }

  Widget _buildEmptyMessage() {
    return Center(child: Text('There are no students in this class.'));
  }

  void _navigateToAddStudentToClass() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider<StudentBloc>(
          create: (context) => StudentBloc(ClassRepository(), UserRepository(), StudentRepository()),
          child: AddStudentToClass(classId: widget.classId),
        ),
      ),
    );
  }

  void _navigateToStudentDetail(String name, String dob, List<String> guardians, String classId, String studentId) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider<StudentBloc>(
          create: (context) => StudentBloc(ClassRepository(), UserRepository(), StudentRepository()),
          child: StudentDetail(
            name: name,
            dob: dob,
            guardians: guardians,
            classId: classId,
            studentId: studentId,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _studentBloc.close();
    _leaveRequestBloc.close();
    super.dispose();
  }
}
