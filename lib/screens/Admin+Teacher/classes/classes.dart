// class_display_screen.dart
import 'package:bumblebee/bloc/Admin+Teacher/classes/classes_bloc.dart';
import 'package:bumblebee/bloc/Admin+Teacher/classes/classes_event.dart';
import 'package:bumblebee/bloc/Admin+Teacher/classes/classes_state.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/class_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassDisplayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Classes")),
      body: BlocBuilder<ClassBloc, ClassState>(builder: (context, state) {
        if (state is ClassesLoaded) {
          return ListView.builder(
            itemCount: state.classes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(state.classes[index].className),
              );
            },
          );
        } else if (state is ClassInitial) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Center(child: Text('Failed to load classes'));
        }
      }),
    );
  }
}

