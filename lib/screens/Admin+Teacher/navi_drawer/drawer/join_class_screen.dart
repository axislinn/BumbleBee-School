import 'package:bumblebee_school/bloc/Admin+Teacher/classes/create_edit_bloc/class_bloc.dart';
import 'package:bumblebee_school/bloc/Admin+Teacher/classes/create_edit_bloc/class_event.dart';
import 'package:bumblebee_school/models/Admin+Teacher/class_model.dart';
import 'package:bumblebee_school/screens/Admin+Teacher/classes/classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JoinClassPage extends StatelessWidget {

  @override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Screen'),
            actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Trigger loading of classes again
              context.read<ClassBloc>().add(LoadClasses());
            },
          ),
        ],
    ),
    
    body: Column(
      children: [
        Expanded(child: ClassDisplayScreen()),  // Main content stays the same
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () => _showCreateClassDialog(context),  // Opens the dialog for creating a class
      child: Icon(Icons.add),  // The '+' icon for adding a class
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,  // Places the button at the bottom center
  );
}


  void _showCreateClassDialog(BuildContext context) {
    final classNameController = TextEditingController();
    final gradeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create Class'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: classNameController,
                decoration: InputDecoration(labelText: 'Class Name'),
              ),
              TextField(
                controller: gradeController,
                decoration: InputDecoration(labelText: 'Grade'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (classNameController.text.isNotEmpty && gradeController.text.isNotEmpty) {
                  final newClass = Class(
                    id: '',
                    className: classNameController.text,
                    grade: gradeController.text, 
                    classCode: '', school: '', students: [], teachers: [], guardians: [], announcements: [],
                  );
                  context.read<ClassBloc>().add(CreateClass(newClass));
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Both fields are required!'),
                  ));
                }
              },
              child: Text('Create'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

