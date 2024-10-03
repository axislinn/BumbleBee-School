import 'package:bumblebee/bloc/Admin+Teacher/classes/create_edit_bloc/class_bloc.dart';
import 'package:bumblebee/bloc/Admin+Teacher/classes/create_edit_bloc/class_event.dart';
import 'package:bumblebee/bloc/Admin+Teacher/classes/create_edit_bloc/class_state.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/class_repository.dart';
import 'package:bumblebee/models/Admin+Teacher/class_model.dart';
import 'package:bumblebee/screens/Admin+Teacher/classes/student_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassDisplayScreen extends StatefulWidget {
  @override
  _ClassDisplayScreenState createState() => _ClassDisplayScreenState();
}

class _ClassDisplayScreenState extends State<ClassDisplayScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger loading of classes when the screen is initialized
    context.read<ClassBloc>().add(LoadClasses());
  }

  void _showEditDialog(Class classToEdit) {
    final classNameController = TextEditingController(text: classToEdit.className);
    final gradeController = TextEditingController(text: classToEdit.grade);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Class'),
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
                final updatedClassData = {
                  'classId': classToEdit.id, // Ensure this is correctly set
                  'grade': gradeController.text,
                  'className': classNameController.text,
                };

                context.read<ClassBloc>().add(EditClass(updatedClassData)); // Send updated class data
                Navigator.of(context).pop();
              },
              child: Text('Save'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ClassBloc, ClassState>(
        builder: (context, state) {
          if (state is ClassLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ClassError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is ClassLoaded) {
            return ListView.builder(
              itemCount: state.classes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.classes[index].className),
                  subtitle: Text('Grade: ${state.classes[index].grade}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentList(classId: state.classes[index].id),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showEditDialog(state.classes[index]),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Delete Class'),
                                content: Text('Are you sure you want to delete this class?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      context.read<ClassBloc>().add(DeleteClass(state.classes[index].id));
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Delete'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text('Cancel'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
