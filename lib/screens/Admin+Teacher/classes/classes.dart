import 'package:bumblebee/bloc/Admin+Teacher/classes/bloc/class_bloc.dart';
import 'package:bumblebee/bloc/Admin+Teacher/classes/bloc/class_event.dart';
import 'package:bumblebee/bloc/Admin+Teacher/classes/bloc/class_state.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/class_repository.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassBloc, ClassState>(
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
                trailing: IconButton(
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
              );
            },
          );
        }
        return Container();
      },
    );
  }
}
