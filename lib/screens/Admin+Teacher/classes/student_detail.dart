import 'package:bumblebee/bloc/Admin+Teacher/classes/create_edit_bloc/class_bloc.dart';
import 'package:bumblebee/bloc/Admin+Teacher/classes/create_edit_bloc/class_event.dart';
import 'package:bumblebee/bloc/Admin+Teacher/classes/create_edit_bloc/class_state.dart';
import 'package:bumblebee/bloc/Admin+Teacher/classes/student_bloc/student_bloc.dart';
import 'package:bumblebee/screens/Admin+Teacher/bottom_nav/bottom_nav.dart';
import 'package:bumblebee/screens/Admin+Teacher/navi_drawer/navi_drawer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentDetail extends StatefulWidget {
  final String name;
  final String dob;
  final List<String> guardians; // List of guardian IDs
  final String classId;
  final String studentId;

  const StudentDetail({
    Key? key,
    required this.name,
    required this.dob,
    required this.guardians,
    required this.classId,
    required this.studentId,
  }) : super(key: key);

  @override
  _StudentDetailState createState() => _StudentDetailState();
}

class _StudentDetailState extends State<StudentDetail> {
  @override
  void initState() {
    super.initState();
    
    // Trigger event to fetch guardians and pending requests when the widget is initialized
    BlocProvider.of<StudentBloc>(context).add(FetchGuardiansEvent(widget.guardians));
    BlocProvider.of<StudentBloc>(context).add(FetchPendingRequestsEvent(widget.classId, widget.studentId));
  }

  @override
  Widget build(BuildContext context) {
    print("student_detail.dart This is $widget.studentId & $widget.name & $widget.dob");
    return DefaultTabController(
      length: 2, // Two tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.name}\'s Details'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Info'),
              Tab(text: 'Guardians'),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  // First Tab: Student Info
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${widget.name}', style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 8),
                        Text('Date of Birth: ${widget.dob}', style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),

                  // Second Tab: Guardians List
                  BlocBuilder<StudentBloc, StudentState>(builder: (context, state) {
                    if (state is GuardiansLoadingState || state is PendingRequestsLoadingState) {
                      return const Center(child: CircularProgressIndicator()); // Show loading indicator
                    } else if (state is GuardiansErrorState) {
                      return Center(child: Text(state.message, style: const TextStyle(fontSize: 16)));
                    } else if (state is GuardiansLoadedState) {
                      final confirmedGuardians = state.guardians;

                      print("student_detail.dart testing loaded state $confirmedGuardians");

                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            confirmedGuardians.length == 0
                                ? const Text('No guardians found.', style: TextStyle(fontSize: 16)) // There is error here. This text is not displayed even if there are no guardians. The debugging text is also not printed. There might be issues with state. It is not guardian loaded state.
                                : Container(
                                  color: Colors.red,
                                    height: confirmedGuardians.length * 80.0,
                                    child: ListView.builder(
                                      itemCount: confirmedGuardians.length,
                                      itemBuilder: (context, index) {
                                        final guardian = confirmedGuardians[index];
                                        return ListTile(
                                          leading: const Icon(Icons.person),
                                          title: Text(guardian.userName),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Relationship: ${guardian.relationship[0]}'),
                                              Text('Phone: ${guardian.phone}'),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                            // Display Pending Requests
                            BlocBuilder<StudentBloc, StudentState>(builder: (context, state) {
                              print("student_detail.dart this is not loaded state");
                              if (state is PendingRequestsLoadedState) {
                                print("student_detail.dart this is  loaded state");
                                final pendingRequests = state.pendingRequests;
                                print("student_detail.dart pending req testing $pendingRequests");
                                if (pendingRequests.isNotEmpty) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 16),
                                      const Text('Pending Requests:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                      Container(
                                        height: pendingRequests.length * 80.0,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: pendingRequests.length,
                                          itemBuilder: (context, index) {
                                            final request = pendingRequests[index];
                                            return ListTile(
                                              leading: const Icon(Icons.person),
                                              title: Text(request.userName),
                                              subtitle: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Relationship: ${request.relationship[0]}'),
                                                  Text('Phone: ${request.phone}'),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return const SizedBox.shrink(); // Return nothing if there are no pending requests
                                }
                              }
                              return const SizedBox.shrink(); // Default case (not expected to reach here)
                            }),
                          ],
                        ),
                      );
                    }
                    return Container(); // Default case (not expected to reach here)
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
