import 'package:bumblebee/bloc/Admin+Teacher/classes/classes_bloc.dart';
import 'package:bumblebee/bloc/Admin+Teacher/classes/classes_event.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/class_repository.dart';
import 'package:bumblebee/screens/Admin+Teacher/classes/classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JoinClassPage extends StatelessWidget {
  final ClassRepository classRepository;

  JoinClassPage({required this.classRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClassBloc(classRepository),
      child: Scaffold(
        appBar: AppBar(title: Text("Admin Dashboard")),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  // Provide Bloc when navigating to ClassDisplayScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => ClassBloc(classRepository)..add(LoadClassesEvent()),
                        child: ClassDisplayScreen(classRepository: classRepository),
                      ),
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
      ),
    );
  }

  void _showAddClassDialog(BuildContext parentContext) {
    final TextEditingController classController = TextEditingController();

    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Add New Class'),
          content: TextField(
            controller: classController,
            decoration: InputDecoration(hintText: 'Enter class name'),
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
                BlocProvider.of<ClassBloc>(parentContext).add(AddClassEvent(classController.text));
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