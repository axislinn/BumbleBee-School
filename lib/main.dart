import 'package:bumblebee/bloc/Admin+Teacher/classes/classes_bloc.dart';
import 'package:bumblebee/bloc/Admin/school_register_bloc/school_register_bloc.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/class_repository.dart';
import 'package:bumblebee/data/repositories/Admin/school_repository.dart';
import 'package:bumblebee/screens/Admin/Admin_home.dart';
import 'package:bumblebee/screens/Admin/register_school.dart';
import 'package:bumblebee/screens/Admin+Teacher/auth/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 // Adjust the import path if needed

// void main() {
//   runApp(MyApp());
// }
 
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: AdminHomePage(), // Make sure this screen exists and is correctly implemented
//     );
//   }
// }


void main() {
  final ClassRepository classRepository = ClassRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ClassBloc(classRepository),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bumblebee',
      home: AdminHomePage(),
    );
  }
}

