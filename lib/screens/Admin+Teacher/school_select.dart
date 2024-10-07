import 'package:bumblebee/bloc/Admin+Teacher/classes/create_edit_bloc/class_bloc.dart';
import 'package:bumblebee/bloc/Admin+Teacher/classes/student_bloc/student_bloc.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/class_repository.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/student_repository.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/user_repository.dart';
import 'package:bumblebee/screens/Admin+Teacher/classes/request_to_join_class.dart';
import 'package:bumblebee/screens/Teacher/link_school.dart';
import 'package:bumblebee/screens/Admin/register_school.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SchoolSelect extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('School'),
      
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SchoolForm(),
                  ),
                );
              },
              child: Text('Register School'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider<StudentBloc>(
                    create: (context) => StudentBloc(ClassRepository(), UserRepository(), StudentRepository()),
                    child: RequestToJoinClass(),
                  ),
                ),
              );
            },
            child: Text('Link With School'),
          ),

          ],
        ),
      ),
    );
  }
}
