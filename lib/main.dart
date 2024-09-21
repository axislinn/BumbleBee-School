import 'package:bumblebee/bloc/Admin/school_register_bloc/school_register_bloc.dart';
import 'package:bumblebee/data/repositories/Admin/school_repository.dart';
import 'package:bumblebee/screens/Admin/register_school.dart';
import 'package:bumblebee/screens/Admin+Teacher/auth/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 // Adjust the import path if needed

void main() {
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // Make sure this screen exists and is correctly implemented
    );
  }
}

