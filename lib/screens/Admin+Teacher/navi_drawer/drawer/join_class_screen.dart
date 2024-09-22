import 'package:bumblebee/bloc/Admin+Teacher/classes/bloc/class_bloc.dart';
import 'package:bumblebee/bloc/Admin+Teacher/classes/bloc/class_event.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/class_repository.dart';
import 'package:bumblebee/models/Admin+Teacher/class_model.dart';
import 'package:bumblebee/screens/Admin+Teacher/classes/classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JoinClassPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Screen')),
      body: Column(
        children: [
          Expanded(child: ClassDisplayScreen()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _showCreateClassDialog(context),
                child: Text('Create Class'),
              ),
            ],
          ),
        ],
      ),
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

