import 'package:bumblebee/bloc/Admin+Teacher/classes/create_edit_bloc/class_bloc.dart';
import 'package:bumblebee/bloc/Admin/school_register_bloc/school_register_bloc.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/class_repository.dart';
import 'package:bumblebee/data/repositories/Admin+Teacher/user_repository.dart';
import 'package:bumblebee/data/repositories/Admin/school_repository.dart';
import 'package:bumblebee/screens/Admin/Admin_home.dart';
import 'package:bumblebee/screens/Admin/register_school.dart';
import 'package:bumblebee/screens/Admin+Teacher/auth/splashscreen.dart';
import 'package:bumblebee/screens/Teacher/Teacher_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), 
    );
  }
}

