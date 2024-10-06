import 'package:bumblebee/bloc/Admin+Teacher/classes/student_bloc/student_bloc.dart';
import 'package:bumblebee/bloc/Admin+Teacher/classes/student_bloc/student_event.dart';
import 'package:bumblebee/bloc/Admin+Teacher/classes/student_bloc/student_state.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/student_repository.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/user_repository.dart';
import 'package:bumblebee/models/Admin+Teacher/class_model.dart';
import 'package:bumblebee/screens/Admin+Teacher/bottom_nav/bottom_nav.dart';
import 'package:bumblebee/screens/Admin+Teacher/classes/class_detail.dart';
import 'package:bumblebee/screens/Admin+Teacher/classes/request_to_join_class.dart';
import 'package:bumblebee/screens/Admin+Teacher/navi_drawer/navi_drawer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassList extends StatefulWidget {
  @override
  _ClassListState createState() => _ClassListState();
}

class _ClassListState extends State<ClassList> {
  late StudentBloc _studentBloc;

  @override
  void initState() {
    super.initState();
    _studentBloc = StudentBloc(StudentRepository(), UserRepository());
    _studentBloc.add(FetchClassesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StudentBloc>.value(
      value: _studentBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Classes'),
        ),
        endDrawer: const NaviDrawer(),
        bottomNavigationBar: const BottomNav(),
        floatingActionButton: FloatingActionButton(
          onPressed: _navigateToRequestToJoinClass,
          child: Icon(Icons.add),
          tooltip: 'Request to join class',
        ),
        body: BlocBuilder<StudentBloc, StudentState>(
          builder: (context, state) {
            if (state is StudentLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is StudentErrorState) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is StudentLoadedState) {
              if (state.classes.isEmpty) {
                return Center(child: Text('No classes available'));
              }

              return _buildClassList(state.classes);
            }
            return Container(); // Return empty container if state does not match
          },
        ),
      ),
    );
  }

  Widget _buildClassList(List<Class> classes) {
    return ListView.builder(
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final classModel = classes[index];
        return ListTile(
          title: Text(classModel.className),
          subtitle: Text('Grade: ${classModel.grade}, Code: ${classModel.classCode}'),
          onTap: () => _navigateToStudentList(classModel.id),
        );
      },
    );
  }

  void _navigateToStudentList(String classId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentList(classId: classId),
      ),
    );
  }

  void _navigateToRequestToJoinClass() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RequestToJoinClass(),
      ),
    );
  }

  @override
  void dispose() {
    _studentBloc.close(); // Close the bloc when the widget is disposed
    super.dispose();
  }
}
