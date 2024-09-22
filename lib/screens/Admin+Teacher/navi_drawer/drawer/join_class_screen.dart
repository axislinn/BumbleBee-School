import 'package:bumblebee/bloc/Admin+Teacher/classes/classes_bloc.dart';
import 'package:bumblebee/bloc/Admin+Teacher/classes/classes_event.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/class_repository.dart';
import 'package:bumblebee/screens/Admin+Teacher/classes/classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JoinClassPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Dashboard")),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClassDisplayScreen(),
                  ),
                );
              },
              child: Text("View Classes"),
            ),
            ElevatedButton(
              onPressed: () {
                _showAddClassDialog(context);
              },
              child: Text("Add Class"),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddClassDialog(BuildContext parentContext) {
    final TextEditingController classController = TextEditingController();
    final TextEditingController gradeController = TextEditingController();
    final TextEditingController codeController = TextEditingController();
    final TextEditingController schoolController = TextEditingController();

    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Add New Class'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: classController,
                  decoration: InputDecoration(hintText: 'Enter class name'),
                ),
                TextField(
                  controller: gradeController,
                  decoration: InputDecoration(hintText: 'Enter grade'),
                ),
                TextField(
                  controller: codeController,
                  decoration: InputDecoration(hintText: 'Enter class code'),
                ),
                TextField(
                  controller: schoolController,
                  decoration: InputDecoration(hintText: 'Enter school name'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Use the correct context to access the ClassBloc
                BlocProvider.of<ClassBloc>(parentContext).add(AddClassEvent(
                  className: classController.text,
                  grade: gradeController.text,
                  classCode: codeController.text,
                  school: schoolController.text,
                ));
                Navigator.pop(dialogContext);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

